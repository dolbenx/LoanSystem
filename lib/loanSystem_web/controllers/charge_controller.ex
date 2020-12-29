defmodule LoanSystemWeb.ChargeController do
  use LoanSystemWeb, :controller

  alias LoanSystem.Loan
  alias LoanSystem.Loan.Charge

  def index(conn, _params) do
    charges = Loan.list_charges()
    render(conn, "index.html", charges: charges)
  end

  def new(conn, _params) do
    changeset = Loan.change_charge(%Charge{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"charge" => charge_params}) do
    case Loan.create_charge(charge_params) do
      {:ok, charge} ->
        conn
        |> put_flash(:info, "Charge created successfully.")
        |> redirect(to: Routes.charge_path(conn, :show, charge))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    charge = Loan.get_charge!(id)
    render(conn, "show.html", charge: charge)
  end

  def edit(conn, %{"id" => id}) do
    charge = Loan.get_charge!(id)
    changeset = Loan.change_charge(charge)
    render(conn, "edit.html", charge: charge, changeset: changeset)
  end

  def update(conn, %{"id" => id, "charge" => charge_params}) do
    charge = Loan.get_charge!(id)

    case Loan.update_charge(charge, charge_params) do
      {:ok, charge} ->
        conn
        |> put_flash(:info, "Charge updated successfully.")
        |> redirect(to: Routes.charge_path(conn, :show, charge))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", charge: charge, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    charge = Loan.get_charge!(id)
    {:ok, _charge} = Loan.delete_charge(charge)

    conn
    |> put_flash(:info, "Charge deleted successfully.")
    |> redirect(to: Routes.charge_path(conn, :index))
  end
end
