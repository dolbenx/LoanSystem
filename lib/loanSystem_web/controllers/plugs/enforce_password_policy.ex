defmodule LoanSystemWeb.Plugs.EnforcePasswordPolicy do
  @behaviour Plug
  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]

  alias LoanSystem.Accounts

  def init(_params) do
  end

  def call(conn, _params) do

    user_id = get_session(conn, :current_user) || get_session(conn, :current_client)
    user = user_id && Accounts.get_user!(user_id)

    with true <- not is_nil(user) && user.auto_password == "Y" do
      conn
      |> put_flash(:error, "Password reset is required!")
      |> redirect(to: LoanSystemWeb.Router.Helpers.user_path(conn, :new_password))
      |> halt()
    else
      _ -> conn
    end
  end
end
