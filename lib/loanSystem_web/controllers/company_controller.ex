defmodule LoanSystemWeb.ReportsController do
  use LoanSystemWeb, :controller

  def reports(conn, _params) do
    render(conn, "reports.html")
  end

  def logs(conn, _params) do
    render(conn, "logs.html")
  end

end
