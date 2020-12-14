defmodule MfUssdWeb.UserController do
  use MfUssdWeb, :controller
  import Ecto.Query, warn: false
  alias MfUssd.{Logs, Repo, Logs.UserLogs, Auth}
  alias MfUssd.Accounts
  alias MfUssd.Accounts.User
  alias MfUssd.Emails.Email
  alias MfUssdWeb.Plugs.EnforcePasswordPolicy

  plug(
    MfUssdWeb.Plugs.RequireAuth
    when action in [
           :new,
           :dashboard,
           :change_password,
           :new_password,
           :list_users,
           :edit,
           :delete,
           :update,
           :create,
           :update_status,
           :user_actitvity,
           :user_management,
           :view_mgt_user,
           :deactivate_account,
           :users_on_leave,
           :activate_user_on_leave,
           :dismissed_users,
           :activate_dismissed_user,
           :suspended_users,
           :activate_suspended_user,
           :retired_users,
           :activate_retired_user

         ]
  )

  # plug(
  #   ProlegalsWeb.Plugs.EnforcePasswordPolicy
  #   when action not in [:new_password, :change_password]
  # )

  # plug(
  #   ProlegalsWeb.Plugs.RequireAdminAccess
  #   when action not in [
  #     :new_password,
  #     :change_password,
  #     :dashboard,
  #     :user_actitvity
  #   ]
  # )


  def list_users(conn, _params) do
    users =
      Accounts.get_user()
      |> Enum.map(&%{&1 | id: sign_user_id(conn, &1.id)})

    page = %{first: "Users", last: "System users"}
    render(conn, "list_users.html", users: users, page: page)
  end

  def dashboard(conn, _params) do
    # conn.assigns.user
    # IO.inspect "----------------------------------------------------"
    # IO.inspect conn

    render(conn, "dashboard.html"
          )
  end

  defp prepare_dash_result(results) do
    Enum.reduce(default_dashboard(), results, fn item, acc ->
      filtered = Enum.filter(acc, &(&1.day == item.day && &1.status == "assigned"))
      if item not in acc && Enum.empty?(filtered), do: [item | acc], else: acc
    end)
    |> Enum.sort_by(& &1.day)
  end

  defp default_dashboard do
    today = Date.utc_today()
    days = Date.days_in_month(today)

    Date.range(%{today | day: 1}, %{today | day: days})
    |> Enum.map(&%{count: 0, day: Timex.format!(&1, "%b #{String.pad_leading(to_string(&1.day), 2, "0")}, %Y", :strftime), status: "assigned"})
  end


  def user_actitvity(conn, %{"id" => user_id}) do
    with :error <- confirm_token(conn, user_id) do
      conn
      |> put_flash(:error, "invalid token received")
      |> redirect(to: Routes.user_path(conn, :list_users))
    else
      {:ok, user} ->
        user_logs = Logs.get_user_logs_by(user.id)
        page = %{first: "Users", last: "Activity logs"}
        render(conn, "activity_logs.html", user_logs: user_logs, page: page)
    end
  end

  def activity_logs(conn, _params) do
    results = Logs.get_all_activity_logs()
    page = %{first: "Users", last: "Activity logs"}
    render(conn, "activity_logs.html", user_logs: results, page: page)
  end

  def update_status(conn, %{"id" => id, "status" => status}) do
    with :error <- confirm_token(conn, id) do
      conn
      |> put_flash(:error, "invalid token received")
      |> redirect(to: Routes.user_path(conn, :list_users))
    else
      {:ok, user} ->
        User.changeset(user, %{status: status})
        |> prepare_status_change(conn, user, status)
        |> Repo.transaction()
        |> case do
          {:ok, %{user: _user, user_log: _user_log}} ->
            conn
            |> put_flash(:info, "Changes applied successfully.")
            |> redirect(to: Routes.user_path(conn, :list_users))

          {:error, _failed_operation, failed_value, _changes_so_far} ->
            reason = traverse_errors(failed_value.errors) |> List.first()

            conn
            |> put_flash(:error, reason)
            |> redirect(to: Routes.user_path(conn, :list_users))
        end
    end
  end

  defp prepare_status_change(changeset, conn, user, status) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, changeset)
    |> Ecto.Multi.insert(
      :user_log,
      User_log.changeset(
        %UserLogs{},
        %{
          user_id: conn.assigns.user.id,
          activity: """
          #{
            case status,
              do:
                (
                  "1" -> "Activated"
                  _ -> "Disabled"
                )
          }
          #{user.first_name} #{user.last_name}
          """
        }
      )
    )
  end

  def edit(conn, %{"id" => id}) do
    with :error <- confirm_token(conn, id) do
      conn
      |> put_flash(:error, "invalid token received")
      |> redirect(to: Routes.user_path(conn, :list_users))
    else
      {:ok, user} ->
        user = %{user | id: sign_user_id(conn, user.id)}
        page = %{first: "Users", last: "Edit user"}
        render(conn, "edit.html", result: user, page: page)
    end
  end

  def update(conn, %{"user" => user_params}) do
    with :error <- confirm_token(conn, user_params["id"]) do
      conn
      |> put_flash(:error, "invalid token received")
      |> redirect(to: Routes.user_path(conn, :list_users))
    else
      {:ok, user} ->
        Ecto.Multi.new()
        |> Ecto.Multi.update(:update, User.changeset(user, Map.delete(user_params, "id")))
        |> Ecto.Multi.run(:log, fn %{update: _update} ->
          activity =
            "Modified user details with Email \"#{user.email}\" and First Name \"#{
              user.first_name
            }\""

          user_log = %{
            user_id: conn.assigns.user.id,
            activity: activity
          }

          User_log.changeset(%UserLogs{}, user_log)
          |> Repo.insert()
        end)
        |> Repo.transaction()
        |> case do
          {:ok, %{update: _update, log: _log}} ->
            conn
            |> put_flash(:info, "Changes applied successfully!")
            |> redirect(to: Routes.user_path(conn, :edit, id: user_params["id"]))

          {:error, _failed_operation, failed_value, _changes_so_far} ->
            reason = traverse_errors(failed_value.errors) |> List.first()

            conn
            |> put_flash(:error, reason)
            |> redirect(to: Routes.user_path(conn, :edit, id: user_params["id"]))
        end
    end
  rescue
    _ ->
      conn
      |> put_flash(:error, "An error occurred, reason unknown")
      |> redirect(to: Routes.user_path(conn, :list_users))
  end

  def create(conn, %{"user" => user_params}) do
    pwd = random_string(6)
    user_params = Map.put(user_params, "password", pwd)

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:user, User.changeset(%User{user_id: conn.assigns.user.id}, user_params))
    |> Ecto.Multi.run(:user_log, fn %{user: user} ->
      activity =
        "Created new user with Email \"#{user.email}\" and First Name #{user.first_name}\""

      user_log = %{
        user_id: conn.assigns.user.id,
        activity: activity
      }

      User_log.changeset(%UserLogs{}, user_log)
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user, user_log: _user_log}} ->
        Email.password(pwd, user.email)

        conn
        |> put_flash(
          :info,
          "#{String.capitalize(user.first_name)} created successfully and password is: #{pwd}"
        )
        |> redirect(to: Routes.user_path(conn, :list_users))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.user_path(conn, :list_users))
    end
  rescue
    _ ->
      conn
      |> put_flash(:error, "An error occurred, reason unknown. try again")
      |> redirect(to: Routes.user_path(conn, :list_users))
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    Ecto.Multi.new()
    |> Ecto.Multi.delete(:user, user)
    |> Ecto.Multi.run(:user_log, fn %{user: user} ->
      activity = "Deleted user with Email \"#{user.email}\" and First Name \"#{user.first_name}\""

      user_log = %{
        user_id: conn.assigns.user.id,
        activity: activity
      }

      User_log.changeset(%UserLogs{}, user_log)
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user, user_log: _user_log}} ->
        conn
        |> put_flash(:info, "#{String.capitalize(user.first_name)} deleted successfully.")
        |> redirect(to: Routes.user_path(conn, :list_users))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.user_path(conn, :list_users))
    end
  end

  def get_user_by_email(email) do
    case Repo.get_by(User, email: email) do
      nil -> {:error, "invalid email address"}
      user -> {:ok, user}
    end
  end

  def get_user_by(nt_username) do
    case Repo.get_by(User, nt_username: nt_username) do
      nil -> {:error, "invalid username/password"}
      user -> {:ok, user}
    end
  end

  defp sign_user_id(conn, id),
    do: Phoenix.Token.sign(conn, "user salt", id, signed_at: System.system_time(:second))

  # ------------------ Password Reset ---------------------
  def new_password(conn, _params) do
    page = %{first: "Settings", last: "Change password"}
    render(conn, "change_password.html", page: page)
  end

  def forgot_password(conn, _params) do
    conn
    |> put_layout(false)
    |> render("forgot_password.html")
  end

  def token(conn, %{"user" => user_params}) do
    with {:error, reason} <- get_user_by_email(user_params["email"]) do
      conn
      |> put_flash(:error, reason)
      |> redirect(to: Routes.user_path(conn, :forgot_password))
    else
      {:ok, user} ->
        token =
          Phoenix.Token.sign(conn, "user salt", user.id, signed_at: System.system_time(:second))

        Email.confirm_password_reset(token, user.email)

        conn
        |> put_flash(:info, "We have sent you a mail")
        |> redirect(to: Routes.session_path(conn, :new))
    end
  end

  defp confirm_token(conn, token) do
    case Phoenix.Token.verify(conn, "user salt", token, max_age: 86400) do
      {:ok, user_id} ->
        user = Repo.get!(User, user_id)
        {:ok, user}

      {:error, _} ->
        :error
    end
  end

  def default_password(conn, %{"token" => token}) do
    with :error <- confirm_token(conn, token) do
      conn
      |> put_flash(:error, "Invalid/Expired token")
      |> redirect(to: Routes.user_path(conn, :forgot_password))
    else
      {:ok, user} ->
        pwd = random_string(6)

        case Accounts.update_user(user, %{password: pwd, auto_password: "Y"}) do
          {:ok, _user} ->
            Email.password_alert(user.email, pwd)

            conn
            |> put_flash(:info, "Password reset successful")
            |> redirect(to: Routes.session_path(conn, :new))

          {:error, _reason} ->
            conn
            |> put_flash(:error, "An error occured, try again!")
            |> redirect(to: Routes.user_path(conn, :forgot_password))
        end
    end
  end

  def reset_pwd(conn, %{"id" => id}) do
    with :error <- confirm_token(conn, id) do
      conn
      |> put_flash(:error, "invalid token received")
      |> redirect(to: Routes.user_path(conn, :list_users))
    else
      {:ok, user} ->
        pwd = random_string(6)
        changeset = User.changeset(user, %{password: pwd, auto_password: "Y"})

        Ecto.Multi.new()
        |> Ecto.Multi.update(:user, changeset)
        |> Ecto.Multi.insert(
          :user_log,
          User_log.changeset(
            %UserLogs{},
            %{
              user_id: conn.assigns.user.id,
              activity: """
              Reserted account password for user with mail \"#{user.email}\"
              """
            }
          )
        )
        |> Repo.transaction()
        |> case do
          {:ok, %{user: user, user_log: _user_log}} ->
            Email.password(user.email, pwd)
            conn |> json(%{"info" => "Password changed to: #{pwd}"})

          # conn |> json(%{"info" => "Password changed successfully"})

          {:error, _failed_operation, failed_value, _changes_so_far} ->
            reason = traverse_errors(failed_value.errors) |> List.first()
            conn |> json(%{"error" => reason})
        end
    end
  end

  def change_password(conn, %{"user" => user_params}) do
    case confirm_old_password(conn, user_params) do
      false ->
        conn
        |> put_flash(:error, "some fields were submitted empty!")
        |> redirect(to: Routes.user_path(conn, :new_password))

      result ->
        with {:error, reason} <- result do
          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.user_path(conn, :new_password))
        else
          {:ok, _} ->
            conn.assigns.user
            |> change_pwd(user_params)
            |> Repo.transaction()
            |> case do
              {:ok, %{update: _update, insert: _insert}} ->
                conn
                |> put_flash(:info, "Password changed successful")
                |> redirect(to: Routes.user_path(conn, :new_password))

              {:error, _failed_operation, failed_value, _changes_so_far} ->
                reason = traverse_errors(failed_value.errors) |> List.first()

                conn
                |> put_flash(:error, reason)
                |> redirect(to: Routes.user_path(conn, :new_password))
            end
        end
    end
  # rescue
  #   _ ->
  #     conn
  #     |> put_flash(:error, "Password changed with errors")
  #     |> redirect(to: Routes.user_path(conn, :new_password))
  end

  def change_pwd(user, user_params) do
    pwd = String.trim(user_params["new_password"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(:update, User.changeset(user, %{password: pwd, auto_password: "N"}))
    |> Ecto.Multi.insert(
      :insert,
      User_log.changeset(
        %UserLogs{},
        %{user_id: user.id, activity: "changed account password"}
      )
    )
  end

  defp confirm_old_password(
         conn,
         %{"old_password" => pwd, "new_password" => new_pwd}
       ) do
    # IO.inspect("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
    # IO.inspect conn

    with true <- String.trim(pwd) != "",
         true <- String.trim(new_pwd) != "" do
      Auth.confirm_password(
        conn.assigns.user,
        String.trim(pwd)
      )
    else
      false -> false
    end
  end

  # ------------------ / password reset -------------------
  def traverse_errors(errors) do
    for {key, {msg, _opts}} <- errors, do: "#{key} #{msg}"
  end

  def defaul_dashboard do
    today = Date.utc_today()
    days = Date.days_in_month(today)

    Date.range(%{today | day: 1}, %{today | day: days})
    |> Enum.map(&%{count: 0, day: "#{&1}", status: nil})
  end

  def random_string(length) do
    :crypto.strong_rand_bytes(length)
    |> Base.url_encode64()
    |> binary_part(0, length)
  end

  # ----------------- / user management --------------------
  def user_management(conn, _params) do
    system_users = Accounts.list_tbl_users()
    render(conn, "user_management.html", system_users: system_users)
  end

  def create_user(conn, params) do
    case Accounts.create_user(params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "User added.")
        |> redirect(to: Routes.user_path(conn, :user_management))

        conn

      {:error, _} ->
        conn
        |> put_flash(:error, "Failed to add user to system.")
        |> redirect(to: Routes.user_path(conn, :user_management))
    end
  end

  def view_mgt_user(conn, %{"id" => id}) do
    view_users  = Accounts.get_user!(id)
    render(conn, "view_management.html", view_users: view_users)
  end

  # ---------------------- Deactivate Account ---------------------------------------
  def deactivate_account(conn, %{"id" => id} = params) do
    system_users = Accounts.get_user!(id)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:system_users, User.changeset(system_users, params))
    |> Ecto.Multi.run(:userlogs, fn %{system_users: system_users} ->
      activity = "ProLegals user account deactivated with ID \"#{system_users.id}\""

      userlogs = %{
        user_id: conn.assigns.user.id,
        activity: activity
      }

      UserLogs.changeset(%UserLogs{}, userlogs)
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{system_users: _system_users, userlogs: _userlogs}} ->
        conn
        |> put_flash(:info, "ProLegals system user account deactivated :-) ")
        |> redirect(to: Routes.user_path(conn, :user_management))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.user_path(conn, :user_management))
    end
  end

  # ---------------------- Leave Account --------------------------------------------

  def users_on_leave(conn, _params) do
    users_on_leave = Accounts.list_tbl_users()
    render(conn, "users_on_leave.html", users_on_leave: users_on_leave)
  end

  def activate_user_on_leave(conn, %{"id" => id} = params) do
    users_on_leaves = Accounts.get_user!(id)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:users_on_leaves, User.changeset(users_on_leaves, params))
    |> Ecto.Multi.run(:userlogs, fn %{users_on_leaves: users_on_leaves} ->
      activity = "User Account on leave activated with ID \"#{users_on_leaves.id}\""

      userlogs = %{
        user_id: conn.assigns.user.id,
        activity: activity
      }

      UserLogs.changeset(%UserLogs{}, userlogs)
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{users_on_leaves: _users_on_leaves, userlogs: _userlogs}} ->
        conn
        |> put_flash(:info, "ProLegals system leave account activated :-) ")
        |> redirect(to: Routes.user_path(conn, :users_on_leave))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.user_path(conn, :users_on_leave))
    end
  end

  # -------------------------- Dismissed Account ------------------------------------------

  def dismissed_users(conn, _params) do
    dismissed_users = Accounts.list_tbl_users()
    render(conn, "dismissed_users.html", dismissed_users: dismissed_users)
  end

  def activate_dismissed_user(conn, %{"id" => id} = params) do
    dismissed_users = Accounts.get_user!(id)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:dismissed_users, User.changeset(dismissed_users, params))
    |> Ecto.Multi.run(:userlogs, fn %{dismissed_users: dismissed_users} ->
      activity = "ProLegals dismissed account activated with ID \"#{dismissed_users.id}\""

      userlogs = %{
        user_id: conn.assigns.user.id,
        activity: activity
      }

      UserLogs.changeset(%UserLogs{}, userlogs)
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{dismissed_users: _dismissed_users, userlogs: _userlogs}} ->
        conn
        |> put_flash(:info, "ProLegals system dismissed account activated :-) ")
        |> redirect(to: Routes.user_path(conn, :dismissed_users))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.user_path(conn, :dismissed_users))
    end
  end

  # --------------------------- Suspended Account --------------------------------------------------
  def suspended_users(conn, _params) do
    suspended_users = Accounts.list_tbl_users()
    render(conn, "suspended_users.html", suspended_users: suspended_users)
  end

  def activate_suspended_user(conn, %{"id" => id} = params) do
    suspended_user = Accounts.get_user!(id)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:suspended_user, User.changeset(suspended_user, params))
    |> Ecto.Multi.run(:userlogs, fn %{suspended_user: suspended_user} ->
      activity = "Suspended account activated with ID \"#{suspended_user.id}\""

      userlogs = %{
        user_id: conn.assigns.user.id,
        activity: activity
      }

      UserLogs.changeset(%UserLogs{}, userlogs)
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{suspended_user: _suspended_user, userlogs: _userlogs}} ->
        conn
        |> put_flash(:info, "ProLegals system suspended account activated :-) ")
        |> redirect(to: Routes.user_path(conn, :suspended_users))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.user_path(conn, :suspended_users))
    end
  end

   # ----------------------- Retired Account  --------------------------------------------------------

   def retired_users(conn, _params) do
    retired_users = Accounts.list_tbl_users()
    render(conn, "retired_users.html", retired_users: retired_users)
  end

  def activate_retired_user(conn, %{"id" => id} = params) do
    retired_users = Accounts.get_user!(id)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:retired_users, User.changeset(retired_users, params))
    |> Ecto.Multi.run(:userlogs, fn %{retired_users: retired_users} ->
      activity = "ProLegals retired account activated with ID \"#{retired_users.id}\""

      userlogs = %{
        user_id: conn.assigns.user.id,
        activity: activity
      }

      UserLogs.changeset(%UserLogs{}, userlogs)
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{retired_users: _retired_users, userlogs: _userlogs}} ->
        conn
        |> put_flash(:info, "ProLegals system retired account activated :-) ")
        |> redirect(to: Routes.user_path(conn, :retired_users))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.user_path(conn, :retired_users))
    end
  end

  # ------------------------ User Logs -----------------------------------------

  def user_logs(conn, _params) do
    logs = Logs.list_tbl_user_logs()
    render(conn, "user_logs.html", logs: logs)
  end

end
