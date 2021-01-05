defmodule LoanSystemWeb.LoanProductChargeController do
  use LoanSystemWeb, :controller

  alias LoanSystem.Loan
  alias LoanSystem.Loan.LoanProductCharge

  def index(conn, _params) do
    loan_product_charges = Loan.list_loan_product_charges()
    render(conn, "index.html", loan_product_charges: loan_product_charges)
  end

  def new(conn, _params) do
    changeset = Loan.change_loan_product_charge(%LoanProductCharge{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"loan_product_charge" => loan_product_charge_params}) do
    case Loan.create_loan_product_charge(loan_product_charge_params) do
      {:ok, loan_product_charge} ->
        conn
        |> put_flash(:info, "Loan product charge created successfully.")
        |> redirect(to: Routes.loan_product_charge_path(conn, :show, loan_product_charge))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    loan_product_charge = Loan.get_loan_product_charge!(id)
    render(conn, "show.html", loan_product_charge: loan_product_charge)
  end

  def edit(conn, %{"id" => id}) do
    loan_product_charge = Loan.get_loan_product_charge!(id)
    changeset = Loan.change_loan_product_charge(loan_product_charge)
    render(conn, "edit.html", loan_product_charge: loan_product_charge, changeset: changeset)
  end

  def update(conn, %{"id" => id, "loan_product_charge" => loan_product_charge_params}) do
    loan_product_charge = Loan.get_loan_product_charge!(id)

    case Loan.update_loan_product_charge(loan_product_charge, loan_product_charge_params) do
      {:ok, loan_product_charge} ->
        conn
        |> put_flash(:info, "Loan product charge updated successfully.")
        |> redirect(to: Routes.loan_product_charge_path(conn, :show, loan_product_charge))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", loan_product_charge: loan_product_charge, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    loan_product_charge = Loan.get_loan_product_charge!(id)
    {:ok, _loan_product_charge} = Loan.delete_loan_product_charge(loan_product_charge)

    conn
    |> put_flash(:info, "Loan product charge deleted successfully.")
    |> redirect(to: Routes.loan_product_charge_path(conn, :index))
  end
end
