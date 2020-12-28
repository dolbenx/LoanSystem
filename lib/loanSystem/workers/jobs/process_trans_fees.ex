defmodule SmartPAY.Jobs.ProcessTransactionFees do
  alias SmartPAY.Admin
  alias SmartPAY.Repo
  alias SmartPAY.BankService
  alias SmartPAY.Admin.FeeCollection

  def perform() do
    case Admin.get_pending_fee_collections() do
      [] ->
        IO.inspect("No transaction fee collections pending")

      fee_collections ->
        fee_collections
        # Task.async_stream(fee_collections, fn fee ->  process(fee) end)
        |> Enum.map(fn fee -> process(fee) end)
    end
  end

  def process(fee) do
    dr_acc = fee.dr_acc_num
    cr_acc = fee.cr_acc_num
    # gen_ref()
    ref = ""

    case BankService.get_acc_details(dr_acc) do
      {:ok, acc_dtls} ->
        case sufficient_balance(acc_dtls.balance, fee.amount) do
          {:ok, _msg} ->
            case BankService.transfer_internal(dr_acc, cr_acc, fee.amount, ref) do
              {:ok, transf_dtls} ->
                update_status(fee, transf_dtls, "SUCCESS")

              {:error, error} ->
                update_status(fee, error, "FAILED")
            end

          {:error, error} ->
            IO.inspect(error)
        end

      {:error, msg} ->
        IO.inspect(msg)
    end
  end

  def update_status(fee, params, status) do
    _changes = prepare_changes(fee, params, status)
    status = (status == "SUCCESS" && "COMPLETE") || "PENDING_VERIFICATION"

    Ecto.Multi.new()
    |> Ecto.Multi.update(:update_fee_coll, FeeCollection.changeset(fee, %{status: status}))
    |> Repo.transaction()
    |> case do
      {:ok, %{update_fee_coll: _fee_coll}} ->
        IO.inspect("payment complete")

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        IO.inspect(failed_value)
    end
  end

  def prepare_changes(fee, params, status) do
    %{
      fee_id: fee.id,
      amount: fee.amount,
      payment_type: "PRICIPLE_INTEREST",
      bank_status: (status == "SUCCESS" && "COMPLETE") || "FAILED",
      bank_ref: (status == "SUCCESS" && params.reference) || "",
      bank_date: NaiveDateTime.utc_now(),
      bank_error_code: "1",
      bank_error_descript: (status == "SUCCESS" && "SUCCESS") || params,
      bank_attempt_count: 1,
      app_ref: "app_ref"
    }
  end

  def sufficient_balance(bal, amount) do
    case Decimal.cmp(to_string(bal), amount) do
      bal when bal in [:gt, :eq] ->
        {:ok, "sufficient balance"}

      _ ->
        {:error, "Insufficient balance to cover #{amount}"}
    end
  end
end
