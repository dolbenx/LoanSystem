defmodule LoanSystemWeb.LoanController do
  use LoanSystemWeb, :controller

  alias LoanSystem.Companies
  alias LoanSystem.Settings


  def loan(conn, _params) do
    staff = Companies.list_tbl_staff
    systemparams = Settings.list_tbl_system_params()
    render(conn, "loan.html", staff: staff, systemparams: systemparams)
  end

  def loan_transactions(conn, _params) do
    render(conn, "loan_transactions.html")
  end

  def loan_charge(conn, _params) do
    render(conn, "loan_charge.html")
  end

  def loan_collateral(conn, _params) do
    render(conn, "loan_collateral.html")
  end

  def loan_advance(conn, _params) do
    render(conn, "loan_advance.html")
  end

  def loan_sche_mapping(conn, _params) do
    render(conn, "loan_sche_mapping.html")
  end

  def loan_overdue(conn, _params) do
    render(conn, "loan_overdue.html")
  end
end
