defmodule SmartPAY.Jobs.UnblockTransactionFees do

  alias SmartPAY.Repo
  alias SmartPAY.Admin
  alias SmartPAY.Assessments
  alias SmartPAY.Admin.FeeCollection

  def perform() do
    case Admin.get_blocked_fee_collections() do
      [] -> IO.inspect "No Blocked transaction fee collections"
      fees ->
        fees
        # Task.async_stream(fees, fn fee ->  process(fee) end)
        |> Enum.map(fn(fee) -> process(fee) end)
    end
  end

  def process(fee) do
    case get_item(fee) do
      nil -> 
        IO.inspect "Fee item not found"
      item ->
        case item.status=="COMPLETE" do
          true ->
            update_fee(fee, "PENDING")
          false ->
            IO.inspect "item transaction not complete"
        end
    end
  end

  def get_item(fee) do
    case fee.fee_category do
      "ZRA_AW_FEE"-> 
        assessment = Assessment.get_assessment!(fee.item_id)
      "ZRA_DOMT_FEE"-> IO.inspect "Processing status=pending"
      "ENAPSA_FEE"-> IO.inspect "Processing status=pending"
      "ZRA_AW_FEE_MISC"-> IO.inspect "Processing status=pending"
      _-> nil
    end
  end

  def update_fee(fee, status) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:update_fee_coll, FeeCollection.changeset(fee, %{status: status}))
    |> Repo.transaction()
    |> case do
      {:ok, %{update_fee_coll: _fee_coll}} ->
        IO.inspect "payment complete"
      {:error, _failed_operation, failed_value, _changes_so_far} ->
        IO.inspect failed_value
      end
   end
  
end
