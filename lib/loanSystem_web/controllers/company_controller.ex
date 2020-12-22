defmodule LoanSystemWeb.CompanyController do
  use LoanSystemWeb, :controller

  def companies(conn, _params) do
    render(conn, "companies.html")
  end
end
