defmodule LoanSystemWeb.ClientPortalController do
  use LoanSystemWeb, :controller


  alias LoanSystem.{Repo, Logs.UserLogs}
  alias LoanSystem.Settings
  # alias FundsMgt.Accounts

  plug(
    LoanSystemWeb.Plugs.RequireAuth
    when action in [
      :index,
      :account,
      :report,
      :setting,
      :error,
      :withdraw,
      :request,
      :invest
    ]
  )


  plug(
    LoanSystemWeb.Plugs.EnforcePasswordPolicy
    when action not in [:new_password, :change_password]
  )


  def new_password(conn, _params) do
    systemparams = Settings.list_tbl_system_params()
    render(conn, Routes.user_path(conn, :new_password, systemparams: systemparams))
  end

  # def change_password(conn, _params) do
  #   render(conn, Routes.user_path(conn, :change_password))
  # end

  def index(conn, _params) do
		render(conn, "index.html")
  end

  def payment_schedule(conn, _params) do
		render(conn, "payment_schedule.html")
  end

  def register_staff(conn, _params) do

		render(conn, "register_staff.html")
  end

  # def client_create_beneficiary(conn, params) d
  #   %{"customer_no" => customer_no} = params
  #   Ecto.Multi.new()
  #     |> Ecto.Multi.insert(:beneficiary_mgt, Beneficiary_mgt.changeset(%Beneficiary_mgt{}, params))
  #       |> Ecto.Multi.run(:user_log, fn(_, %{beneficiary_mgt: _beneficiary_mgt}) ->
  #         activity = "Beneficiary has been Added"
  #         # activity = "Created new fee \"#{fee_management.fee_code}\""
  #     user_log = %{
  #         user_id: conn.assigns.user.id,
  #         activity: activity
  #     }

  #     UserLogs.changeset(%UserLogs{}, user_log)
  #     |> Repo.insert()
  #   end)
  #   |> Repo.transaction()
  #   |> case do
  #     {:ok, %{beneficiary_mgt: _beneficiary_mgt, user_log: _user_log}} ->
  #       conn
  #       |> put_flash(:info, "Beneficiary has been Added Successfully.")
  #       |> redirect(to: Routes.client_portal_path(conn, :beneficiary, customer_no: customer_no))

  #     {:error, _failed_operation, failed_value, _changes_so_far} ->
  #       reason = traverse_errors(failed_value.errors) |> List.first()
  #       conn
  #       |> put_flash(:error, reason)
  #       |> redirect(to: Routes.client_portal_path(conn, :beneficiary, customer_no: customer_no))
  #   end
  # rescue
  #   _ ->
  #     conn
  #     |> put_flash(:error, "An error occurred, reason unknown. try again")
  #     |> redirect(to: Routes.client_portal_path(conn, :beneficiary))
  # end

  def traverse_errors(errors) do
    for {key, {msg, _opts}} <- errors, do: "#{key} #{msg}"
  end

end
