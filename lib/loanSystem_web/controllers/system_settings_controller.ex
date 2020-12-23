defmodule LoanSystemWeb.SystemSettingsController do
  use LoanSystemWeb, :controller

  def bank(conn, _params) do
    render(conn, "bank.html")
  end

  def mno(conn, _params) do
    render(conn, "mno.html")
  end

  def systemparams(conn, _params) do
    render(conn, "systemparams.html")
  end

end
