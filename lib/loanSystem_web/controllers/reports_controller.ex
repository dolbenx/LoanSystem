defmodule LoanSystemWeb.ReportsController do

  import Ecto.Query, warn: false
  use LoanSystemWeb, :controller
  alias LoanSystem.Logs
  alias LoanSystem.Repo
  alias LoanSystem.Settings
  alias LoanSystem.Settings.SystemParams

  def reports(conn, _params) do
    systemparams = Settings.list_tbl_system_params()
    render(conn, "reports.html", systemparams: systemparams)
  end

  def logs(conn, _params) do
    logs = Log.list_tbl_user_logs()
    render(conn, "logs.html", logs: logs)


  end

  def reports(conn, params) do
    IO.inspect "-----------------aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa------------"
    IO.inspect params["end_date"]
  reports = report(params)
  IO.inspect "-----------------mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm------------"
  IO.inspect reports
  #totals = Administration.total()
  #average_numbers = Administration.average_numbers()
  render(conn, "reports.html", reports: reports)
end

def start_date_conversion(params) do
  IO.inspect "TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT"
  IO.inspect params
  IO.inspect "TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT"
  case params["end_date"] == nil do
      true -> []
      false ->

      date =  NaiveDateTime.new Date.from_iso8601!(params["start_date"]), ~T[00:00:00]
      {:ok , changed_date} = date
      start_date1 = Timex.beginning_of_day(changed_date)
      start_date2 = to_string(start_date1)
      start_date = String.slice(start_date2, 0..15)

      IO.inspect start_date, label: "Start date"

    end
end

def end_date_conversion(params) do
    IO.inspect "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU"
    IO.inspect params
    IO.inspect "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU"
  case params["end_date"] == nil do
    true -> []

    false ->
    date =  NaiveDateTime.new Date.from_iso8601!(params["end_date"]), ~T[00:00:00]
    {:ok , changed_date2} = date
    end_date1 = Timex.end_of_day(changed_date2)
    end_date2 = to_string(end_date1)
    end_date = String.slice(end_date2, 0..15)

    IO.inspect end_date, label: "End date"
  end

 end

  def report(params) do

        start_date_conversion(params)
        end_date_conversion(params)

        # if params["loan_type"] == "*" do
          query =
                """
                SELECT * FROM tbl_loans where status = '#{params["loan_type"]}' and (inserted_at BETWEEN '#{params["start_date"]}' AND '#{params["end_date"]}')
                """

                {:ok, %{columns: columns, rows: rows}} = Repo.query(query, [])
                rows |> Enum.map(&Enum.zip(columns, &1)) |> Enum.map(&Enum.into(&1, %{}))

          end
        #  end

 end
