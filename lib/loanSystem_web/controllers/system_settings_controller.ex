defmodule LoanSystemWeb.SystemSettingsController do
  use LoanSystemWeb, :controller

  alias LoanSystem.Repo
  alias LoanSystem.Logs.UserLogs
  alias LoanSystem.Settings
  alias LoanSystem.Settings.SystemParams
  alias LoanSystem.Settings.Bank
  alias LoanSystem.Settings.Mno

  def bank(conn, _params) do
    banks = Settings.list_tbl_banks()
    render(conn, "bank.html", banks: banks)
  end

  def add_bank(conn, params) do
    Ecto.Multi.new()
      |> Ecto.Multi.insert(:banks, Bank.changeset(%Bank{}, params))
        |> Ecto.Multi.run(:user_log, fn(_, %{banks: _banks}) ->
          activity = "Bank has been Added"

      user_log = %{
          user_id: conn.assigns.user.id,
          activity: activity
      }

      UserLogs.changeset(%UserLogs{}, user_log)
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{banks: _banks, user_log: _user_log}} ->
        conn
        |> put_flash(:info, "Bank has been Added Successfully.")
        |> redirect(to: Routes.system_settings_path(conn, :bank))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.system_settings_path(conn, :bank))
    end
  # rescue
  #   _ ->
  #     conn
  #     |> put_flash(:error, "An error occurred, reason unknown. try again")
  #     |> redirect(to: Routes.customer_path(conn, :index))
  end

  def mno(conn, _params) do
    mnos = Settings.list_tbl_mnos()
    render(conn, "mno.html", mnos: mnos)
  end

  def add_mno(conn, params) do
    Ecto.Multi.new()
      |> Ecto.Multi.insert(:mnos, Mno.changeset(%Mno{}, params))
        |> Ecto.Multi.run(:user_log, fn(_, %{mnos: _v}) ->
          activity = "MNO has been Added"

      user_log = %{
          user_id: conn.assigns.user.id,
          activity: activity
      }

      UserLogs.changeset(%UserLogs{}, user_log)
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{mnos: _mnos, user_log: _user_log}} ->
        conn
        |> put_flash(:info, "MNO has been Added Successfully.")
        |> redirect(to: Routes.system_settings_path(conn, :mno))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.system_settings_path(conn, :mno))
    end
  # rescue
  #   _ ->
  #     conn
  #     |> put_flash(:error, "An error occurred, reason unknown. try again")
  #     |> redirect(to: Routes.customer_path(conn, :index))
  end

  def systemparams(conn, _params) do
    systemparams = Settings.list_tbl_system_params()
    render(conn, "systemparams.html", systemparams: systemparams)
  end

  def add_systemparams(conn, params) do
    Ecto.Multi.new()
      |> Ecto.Multi.insert(:systemparams, SystemParams.changeset(%SystemParams{}, params))
        |> Ecto.Multi.run(:user_log, fn(_, %{systemparams: _systemparams}) ->
          activity = "System Params has been Added"

      user_log = %{
          user_id: conn.assigns.user.id,
          activity: activity
      }

      UserLogs.changeset(%UserLogs{}, user_log)
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{systemparams: _systemparams, user_log: _user_log}} ->
        conn
        |> put_flash(:info, "system Params has been Added Successfully.")
        |> redirect(to: Routes.system_settings_path(conn, :systemparams))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.system_settings_path(conn, :systemparams))
    end
  # rescue
  #   _ ->
  #     conn
  #     |> put_flash(:error, "An error occurred, reason unknown. try again")
  #     |> redirect(to: Routes.customer_path(conn, :index))
  end

  def traverse_errors(errors) do
    for {key, {msg, _opts}} <- errors, do: "#{key} #{msg}"
  end

end
