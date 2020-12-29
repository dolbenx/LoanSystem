defmodule LoanSystemWeb.LoanProductController do
  use LoanSystemWeb, :controller

  alias LoanSystem.Loan
  alias LoanSystem.Loan.LoanProduct

  def index(conn, _params) do
    loanproducts = Loan.list_loanproducts()
    render(conn, "index.html", loanproducts: loanproducts)
  end

  def new(conn, _params) do
    changeset = Loan.change_loan_product(%LoanProduct{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"loan_product" => loan_product_params}) do
    case Loan.create_loan_product(loan_product_params) do
      {:ok, loan_product} ->
        conn
        |> put_flash(:info, "Loan product created successfully.")
        |> redirect(to: Routes.loan_product_path(conn, :show, loan_product))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    loan_product = Loan.get_loan_product!(id)
    render(conn, "show.html", loan_product: loan_product)
  end

  def edit(conn, %{"id" => id}) do
    loan_product = Loan.get_loan_product!(id)
    changeset = Loan.change_loan_product(loan_product)
    render(conn, "edit.html", loan_product: loan_product, changeset: changeset)
  end

  def update(conn, %{"id" => id, "loan_product" => loan_product_params}) do
    loan_product = Loan.get_loan_product!(id)

    case Loan.update_loan_product(loan_product, loan_product_params) do
      {:ok, loan_product} ->
        conn
        |> put_flash(:info, "Loan product updated successfully.")
        |> redirect(to: Routes.loan_product_path(conn, :show, loan_product))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", loan_product: loan_product, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    loan_product = Loan.get_loan_product!(id)
    {:ok, _loan_product} = Loan.delete_loan_product(loan_product)

    conn
    |> put_flash(:info, "Loan product deleted successfully.")
    |> redirect(to: Routes.loan_product_path(conn, :index))
  end
end
