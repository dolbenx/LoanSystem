defmodule LoanSystemWeb.ReportsController do
  use LoanSystemWeb, :controller

  alias LoanSystem.Logs

  def reports(conn, _params) do
    render(conn, "reports.html")
  end

  def logs(conn, _params) do
    logs = Logs.list_tbl_user_logs()
    render(conn, "logs.html", logs: logs)
  end

end
