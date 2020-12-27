defmodule SmartPAY.PostBulk do
  alias SmartPAY.BankService

  def post(entry) do
    prepare_req_params(entry)
    |> BankService.post()
    |> case do
      {:ok, resp} ->
        case Map.has_key?(resp, :cbs_ref) do
          true ->
            {:ok, %{ref: resp.cbs_ref}, entry}

          false ->
            {:error, resp.error_descript, entry}
        end

      {:error, error} ->
        {:error, error, entry}
    end
  end

  def prepare_req_params(entry) do
    %{
      dr_acc: entry.src_acc_no,
      cr_acc: (entry.type == "INTERNAL" && entry.destin_acc_no) || entry.ext_gl_acc,
      ref_id: "FT" <> entry.destin_acc_no,
      amount: entry.amount,
      descript: entry.narration,
      currency: "ZMW"
    }
  end
end
