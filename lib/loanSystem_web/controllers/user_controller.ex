defmodule LoanSystemWeb.UserController do
  use LoanSystemWeb, :controller
  use Ecto.Schema
  import Ecto.Query, warn: false
  alias LoanSystem.{Logs, Repo, Logs.UserLogs, Auth}
  alias LoanSystem.Accounts
  alias LoanSystem.Accounts.User
  alias LoanSystem.Accounts.Old_password

  # alias LoanSystem.Accounts.UserRoles
  alias LoanSystem.Emails.Email
  # alias LoanSystemWeb.Plugs.EnforcePasswordPolicy

  plug(
    LoanSystemWeb.Plugs.RequireAuth
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
           :user_roles,
           :user_mgt,
           :user_logs,
           :user_permission,
           :create_roles
         ]
  )

  plug(
    LoanSystemWeb.Plugs.EnforcePasswordPolicy
    when action not in [:new_password, :change_password]
  )

  # plug(
  #   FundsMgtWeb.Plugs.RequireAdminAccess
  #   when action not in [
  #     :new_password,
  #     :change_password,
  #     :dashboard,
  #     :user_actitvity
  #   ]
  # )

  def list_users(conn, _params) do
    pwd = random_string()
    users =
      Accounts.get_user!(User)
      |> Enum.map(&%{&1 | id: sign_user_id(conn, &1.id)})

    page = %{first: "Users", last: "System users"}
    render(conn, "list_users.html", users: users, page: page, pwd: pwd )
  end

  def create_user(conn, params) do
    case Accounts.create_user(params) do
      {:ok, _} ->
        Email.send_email(params["email"], params["password"])
        conn
        |> put_flash(:info, "User added.")
        |> redirect(to: Routes.user_path(conn, :user_mgt))

        conn

      {:error, error} -> IO.inspect error.error

        conn
        |> put_flash(:error, "Failed to add user to system.")
        |> redirect(to: Routes.user_path(conn, :user_mgt))
    end
  end
  def view_user(conn, %{"id" => id}) do
    system_user  = Accounts.get_user!(id)
    system_users  = Accounts.get_user!(id)
    render(conn, "view_user.html", system_user: system_user, system_users: system_users)
  end

  def user_roles(conn, _params) do
    roles = Accounts.list_tbl_user_role()
    render(conn, "user_roles.html", roles: roles)
  end

  def create_roles(conn, params) do
    case Accounts.create_user_roles(params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "User Role Added.")
        |> redirect(to: Routes.user_path(conn, :user_roles))

        conn

      {:error, _} ->
        conn
        |> put_flash(:error, "Failed to add user role.")
        |> redirect(to: Routes.user_path(conn, :user_roles))
    end
  end

  #   def update_role(conn, %{"id" => id} = params) do
  #   user_role = Accounts.get_user_roles!(id)

  #     Ecto.Multi.new()
  #     |> Ecto.Multi.update(:user_role, User_roles.changeset(user_role, params))
  #     |> Ecto.Multi.run(:user_logs, fn (_,%{user_role: user_role}) ->
  #       activity = "Updated User role with ID \"#{user_role.id}\""

  #       user_logs = %{
  #         user_id: conn.assigns.user.id,
  #         activity: activity
  #       }

  #       UserLogs.changeset(%UserLogs{}, user_logs)
  #       |> Repo.insert()
  #     end)
  #     |> Repo.transaction()
  #     |> case do
  #       {:ok, %{user_role: _user_role, user_logs: _user_logs}} ->
  #         conn
  #         |> put_flash(:info, "User role updated successfully.")
  #         |> redirect(to: Routes.user_path(conn, :user_roles))

  #       {:error, _failed_operation, failed_value, _changes_so_far} ->
  #         reason = traverse_errors(failed_value.errors) |> List.first()

  #         conn
  #         |> put_flash(:error, reason)
  #         |> redirect(to: Routes.user_path(conn, :user_roles))
  #     end
  # end
  def update(conn, %{"id" => id} = params) do
    user = Accounts.get_user!(id)

      Ecto.Multi.new()
      |> Ecto.Multi.update(:user, User.changeset(user, params))
      |> Ecto.Multi.run(:user_logs, fn (_,%{user: user}) ->
        activity = "Updated User with ID \"#{user.id}\""

        user_logs = %{
          user_id: conn.assigns.user.id,
          activity: activity
        }

        UserLogs.changeset(%UserLogs{}, user_logs)
        |> Repo.insert()
      end)
      |> Repo.transaction()
      |> case do
        {:ok, %{user: _user, user_logs: _user_logs}} ->
          conn
          |> put_flash(:info, "User updated successfully.")
          |> redirect(to: Routes.user_path(conn, :user_mgt))

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()

          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.user_path(conn, :user_mgt))
      end
  end
  def delete(conn, %{"id" => id} = params) do
    user = Accounts.get_user!(id)
      Ecto.Multi.new()
        |> Ecto.Multi.delete(:user , User.changeset(user, params))
        |> Ecto.Multi.run(:user_log, fn (_,%{user: _user }) ->
        activity = "User Deleted successfully "

      user_log = %{
      user_id: conn.assigns.user.id,
      activity: activity
      }

      UserLogs.changeset(%UserLogs{}, user_log)
      |> Repo.insert()
      end)
        |> Repo.transaction()
        |> case do
        {:ok, %{user: _user, user_log: _user_log}} ->
        conn
        |> put_flash(:info, "User Deleted successfully.")
        |> redirect(to: Routes.user_path(conn, :user_mgt))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
      reason = traverse_errors(failed_value.errors) |> List.first()

      conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.user_path(conn, :user_mgt))
      end
    rescue
    _ ->
    conn
    |> put_flash(:error, "An error occurred, reason unknown. try again")
    |> redirect(to: Routes.user_path(conn, :user_mgt))
  end

  def dashboard(conn, _params) do
    users = Accounts.list_tbl_users()
    user = Accounts.get_user!(conn.assigns.user.id).id
<<<<<<< HEAD
    # last_logged_in = Logs.last_logged_in(user)
    render(conn, "dashboard.html")
=======
   # last_logged_in = Logs.last_logged_in(user)
    render(conn, "dashboard.html", users: users)
>>>>>>> dcbe1ebc8e87f2587ea06d6e88328c4774e74790
  end

  def user_actitvity(conn, %{"id" => user_id}) do
    with :error <- confirm_token(conn, user_id) do
      conn
      |> put_flash(:error, "invalid token received")
      |> redirect(to: Routes.user_path(conn, :list_users))
    else
      {:ok, user} ->
        user_logs = Logs.get_user_logs!(user.id)
        page = %{first: "Users", last: "Activity logs"}
        render(conn, "activity_logs.html", user_logs: user_logs, page: page)
    end
  end

  def activity_logs(conn, _params) do
    results = Logs.list_tbl_user_logs()
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
      UserLogs.changeset(
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
        pwd = random_string()

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
        pwd = random_string()
        changeset = User.changeset(user, %{password: pwd, auto_password: "Y"})

        Ecto.Multi.new()
        |> Ecto.Multi.update(:user, changeset)
        |> Ecto.Multi.insert(
          :user_log,
          UserLogs.changeset(
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
        case result do
          {:error, reason} ->
            conn
            |> put_flash(:error, reason)
            |> redirect(to: Routes.user_path(conn, :new_password))

          {:ok, _} -> james_password_authentication(conn, user_params)
        end
      end
    end

    defp proceed_to_change_password(conn, user, encode_new_pass, user_params) do
      change_pwd(user, user_params)
      |> Repo.transaction()
      |> case do
        {:ok, %{update: _update, insert: _insert}} ->
          keep_old_password = %{
            user_id: user.id,
            email: user.email,
            password: encode_new_pass,
            date_created: Timex.today() |> to_string()
          }
          Old_password.changeset(%Old_password{}, keep_old_password)
          |> Repo.insert()
            conn
            |> put_flash(:info, "Password changed successful, please login below using your new password.")
            |> redirect(to: Routes.session_path(conn, :signout))
        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()
          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.user_path(conn, :new_password))
        end
    end

    defp james_password_authentication(conn, user_params) do
      encode_new_pass = Base.encode16(:crypto.hash(:sha512, user_params["new_password"]))
      old_password(conn)
      |> case do
        [] -> proceed_to_change_password(conn, conn.assigns.user, encode_new_pass, user_params)
        old_pass ->
          old_pass |> Enum.map(& &1.password) |> Enum.member?(encode_new_pass) |> case do
            false -> proceed_to_change_password(conn, conn.assigns.user, encode_new_pass, user_params)
            true ->
              conn |> put_flash(:error, "previous password can only be reused after six months") |> redirect(to: Routes.user_path(conn, :new_password))
          end
      end
  # old_pass |> Enum.map(fn used_pass -> if (used_pass.password == encode_new_pass) do true end end) |> Enum.filter(& !is_nil(&1)) |> Enum.member?(true)
    end

  defp old_password(conn) do
    user = conn.assigns.user.id
    Accounts.check_old_password(user, Timex.today() |> Date.add(-180) |> to_string)
  end

  def change_pwd(user, user_params) do
    pwd = String.trim(user_params["new_password"])
    Ecto.Multi.new()
    |> Ecto.Multi.update(:update, User.changeset(user, %{password: pwd, auto_password: "N"}))
    |> Ecto.Multi.insert(
      :insert,
      UserLogs.changeset(
        %UserLogs{},
        %{user_id: user.id, activity: "changed account password"}
      )
    )
  end

  defp confirm_old_password(
         conn,
         %{"old_password" => pwd, "new_password" => new_pwd}
       ) do

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

  def hash_pass(%{new_password: password_hash} = user, new_password) do
    case Base.encode16(:crypto.hash(:sha512, new_password)) do
      pwd when pwd == password_hash ->
        {:ok, user}

      _ ->
        {:error, "password/username not match"}
    end
  end
  # ------------------ / user management -------------------
  def user_mgt(conn, _params) do
    pwd = random_string()
    system_users = Accounts.list_tbl_users()
   # roles = Accounts.list_tbl_user_role()
    render(conn, "user_mgt.html", system_users: system_users, pwd: pwd)
  end

  def user_logs(conn, _params) do
    logs = Logs.list_tbl_user_logs()
    render(conn, "user_logs.html", logs: logs)
  end

  def user_permission(conn, _params) do
    render(conn, "user_permission.html")
  end

  def deactivate_account(conn, %{"id" => id} = params) do
    system_users = Accounts.get_user!(id)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:system_users, User.changeset(system_users, params))
    |> Ecto.Multi.run(:userlogs, fn (_,%{system_users: system_users}) ->
      activity = "Funds Management system user account deactivated with ID \"#{system_users.id}\""

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
        |> put_flash(:info, "Funds Management system user account deactivated :-) ")
        |> redirect(to: Routes.user_path(conn, :user_mgt))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.user_path(conn, :user_mgt))
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
    |> Ecto.Multi.run(:userlogs, fn (_,%{users_on_leaves: users_on_leaves}) ->
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
        |> put_flash(:info, "Funds Management system leave account activated :-) ")
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
    |> Ecto.Multi.run(:userlogs, fn (_,%{dismissed_users: dismissed_users}) ->
      activity = "Funds Management dismissed account activated with ID \"#{dismissed_users.id}\""

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
        |> put_flash(:info, "Funds Management system dismissed account activated :-) ")
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
    |> Ecto.Multi.run(:userlogs, fn (_,%{suspended_user: suspended_user}) ->
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
        |> put_flash(:info, "Funds Management system suspended account activated :-) ")
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
    |> Ecto.Multi.run(:userlogs, fn (_,%{retired_users: retired_users}) ->
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
        |> put_flash(:info, "Funds Management system retired account activated :-) ")
        |> redirect(to: Routes.user_path(conn, :retired_users))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.user_path(conn, :retired_users))
    end
  end








  def password_render() do
    random_string()
  end

  def number do
    spec =Enum.to_list(?2..?9)
    length = 2
    Enum.take_random(spec, length)
  end
  def number2 do
    spec =Enum.to_list(?1..?9)
    length = 1
    Enum.take_random(spec, length)
  end
  def caplock do
    spec = Enum.to_list(?A..?N)
    length = 1
    Enum.take_random(spec, length)
  end
  def small_latter do
    spec = Enum.to_list(?a..?n)
    length = 1
    Enum.take_random(spec, length)
  end
  def small_latter2 do
    spec = Enum.to_list(?p..?z)
    length = 2
    Enum.take_random(spec, length)
  end
  def special do
    spec = Enum.to_list(?#..?*)
    length = 1
    Enum.take_random(spec, length)|> to_string()|> String.replace("'", "^")|> String.replace("(", "!")|> String.replace(")", "@")
  end

  def random_string do
    smll = to_string(small_latter())
    smll2 = to_string(small_latter2())
    nmb = to_string(number())
    nmb2 = to_string(number2())
    spc = to_string(special())
    cpl = to_string(caplock())
    smll<>""<>nmb<>""<>spc<>""<>cpl<>""<>nmb2<>""<>smll2
  end

  def generate_random_password(conn, _param) do
    account = random_string()
    json(conn, %{"account" => account})
  end















end
