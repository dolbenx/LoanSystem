defmodule LoanSystemWeb.AppUserController do
  use LoanSystemWeb, :controller

  alias LoanSystem.Account
  alias LoanSystem.Account.AppUser

  def index(conn, _params) do
    appusers = Account.list_appusers()
    render(conn, "index.html", appusers: appusers)
  end

  def new(conn, _params) do
    changeset = Account.change_app_user(%AppUser{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"app_user" => app_user_params}) do
    case Account.create_app_user(app_user_params) do
      {:ok, app_user} ->
        conn
        |> put_flash(:info, "App user created successfully.")
        |> redirect(to: Routes.app_user_path(conn, :show, app_user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    app_user = Account.get_app_user!(id)
    render(conn, "show.html", app_user: app_user)
  end

  def edit(conn, %{"id" => id}) do
    app_user = Account.get_app_user!(id)
    changeset = Account.change_app_user(app_user)
    render(conn, "edit.html", app_user: app_user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "app_user" => app_user_params}) do
    app_user = Account.get_app_user!(id)

    case Account.update_app_user(app_user, app_user_params) do
      {:ok, app_user} ->
        conn
        |> put_flash(:info, "App user updated successfully.")
        |> redirect(to: Routes.app_user_path(conn, :show, app_user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", app_user: app_user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    app_user = Account.get_app_user!(id)
    {:ok, _app_user} = Account.delete_app_user(app_user)

    conn
    |> put_flash(:info, "App user deleted successfully.")
    |> redirect(to: Routes.app_user_path(conn, :index))
  end
end
