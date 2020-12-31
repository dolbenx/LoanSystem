defmodule LoanSystemWeb.SessionController do
    use LoanSystemWeb, :controller

    alias LoanSystemWeb.UserController
    alias LoanSystem.Logs
    alias LoanSystem.Auth
    # alias MfzUssd.{Auth, Logs}

    plug(
      LoanSystemWeb.Plugs.RequireAuth
      when action in [:signout]
  )

    def new(conn, _params) do
      conn = put_layout(conn, false)
      render(conn, "index.html")
    end

    def create(conn, params) do
      with {:error, _reason} <- UserController.get_user_by_email(String.trim(params["email"])) do
        conn
        |> put_flash(:error, "Email do not match")
        |> put_layout(false)
        |> render("index.html")
      else
        {:ok, user} ->
          with {:error, _reason} <- Auth.confirm_password(user, String.trim(params["password"])) do
            conn
            |> put_flash(:error, "Password do not match")
            |> put_layout(false)
            |> render("index.html")
          else
            {:ok, _} ->
              cond do
                user.status == 1 ->
                  {:ok, _} = Logs.create_user_logs(%{user_id: user.id, activity: "logged in"})
                    cond do
                      user.user_type == 3 ->
                        conn
                        |> put_session(:current_user, user.id)
                        |> put_session(:session_timeout_at, session_timeout_at())
                        |> redirect(to: Routes.client_portal_path(conn, :index))

                      user.user_type == 1 ->
                        conn
                        |> put_session(:current_user, user.id)
                        |> put_session(:session_timeout_at, session_timeout_at())
                        |> redirect(to: Routes.user_path(conn, :dashboard))

                      user.user_type == 2 ->
                        conn
                        |> put_session(:current_user, user.id)
                        |> put_session(:session_timeout_at, session_timeout_at())
                        |> redirect(to: Routes.user_path(conn, :dashboard))
                    end
                true ->
                  conn
                  # |> put_status(405)
                  # |> put_layout(false)
                  |> redirect(to: Routes.session_path(conn, :error_405))
              end
          end
      end
    # rescue
    #   _ ->
    #     conn
    #     |> put_flash(:error, "An error occured. login failed")
    #     |> put_layout(false)
    #     |> render("index.html")
    end

    defp session_timeout_at do
      DateTime.utc_now() |> DateTime.to_unix() |> (&(&1 + 3_600)).()
    end

    def signout(conn, _params) do
      {:ok, _} = Logs.create_user_logs(%{user_id: conn.assigns.user.id, activity: "logged out"})

      conn
      |> configure_session(drop: true)
      |> redirect(to: Routes.session_path(conn, :new))
    rescue
      _ ->
        conn
        |> configure_session(drop: true)
        |> redirect(to: Routes.session_path(conn, :new))
    end

    def error_405(conn, _params) do
      render(conn, "disabled_account.html")
    end
  end
