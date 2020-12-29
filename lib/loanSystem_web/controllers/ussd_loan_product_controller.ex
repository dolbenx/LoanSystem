defmodule LoanSystemWeb.USSDLoanProductController do
  use LoanSystemWeb, :controller

  alias LoanSystem.Loan
  alias LoanSystem.Loan.USSDLoanProduct

  def index(conn, _params) do
    ussdloanproducts = Loan.list_ussdloanproducts()
    render(conn, "index.html", ussdloanproducts: ussdloanproducts)
  end

  def new(conn, _params) do
    changeset = Loan.change_ussd_loan_product(%USSDLoanProduct{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"ussd_loan_product" => ussd_loan_product_params}) do
    case Loan.create_ussd_loan_product(ussd_loan_product_params) do
      {:ok, ussd_loan_product} ->
        conn
        |> put_flash(:info, "Ussd loan product created successfully.")
        |> redirect(to: Routes.ussd_loan_product_path(conn, :show, ussd_loan_product))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    ussd_loan_product = Loan.get_ussd_loan_product!(id)
    render(conn, "show.html", ussd_loan_product: ussd_loan_product)
  end

  def edit(conn, %{"id" => id}) do
    ussd_loan_product = Loan.get_ussd_loan_product!(id)
    changeset = Loan.change_ussd_loan_product(ussd_loan_product)
    render(conn, "edit.html", ussd_loan_product: ussd_loan_product, changeset: changeset)
  end

  def update(conn, %{"id" => id, "ussd_loan_product" => ussd_loan_product_params}) do
    ussd_loan_product = Loan.get_ussd_loan_product!(id)

    case Loan.update_ussd_loan_product(ussd_loan_product, ussd_loan_product_params) do
      {:ok, ussd_loan_product} ->
        conn
        |> put_flash(:info, "Ussd loan product updated successfully.")
        |> redirect(to: Routes.ussd_loan_product_path(conn, :show, ussd_loan_product))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", ussd_loan_product: ussd_loan_product, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    ussd_loan_product = Loan.get_ussd_loan_product!(id)
    {:ok, _ussd_loan_product} = Loan.delete_ussd_loan_product(ussd_loan_product)

    conn
    |> put_flash(:info, "Ussd loan product deleted successfully.")
    |> redirect(to: Routes.ussd_loan_product_path(conn, :index))
  end
end
