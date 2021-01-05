defmodule LoanSystemWeb.ReportsController do
  use LoanSystemWeb, :controller

  alias LoanSystem.Logs
  alias LoanSystem.Settings
  alias LoanSystem.Settings.SystemParams

  def reports(conn, _params) do
    systemparams = Settings.list_tbl_system_params()
    render(conn, "reports.html", systemparams: systemparams)
  end

  def logs(conn, _params) do
    logs = Logs.list_tbl_user_logs()
    render(conn, "logs.html", logs: logs)
  end

end
