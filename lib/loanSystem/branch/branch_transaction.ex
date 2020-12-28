defmodule LoanSystem.Branch.BranchTransaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_branch_branch_transactions" do
    field :currency_code, :string
    field :details, :string
    field :receipient_branch_id, :string
    field :source_branch_id, :string
    field :transaction_amount, :string
    field :transaction_date, :string

    timestamps()
  end

  @doc false
  def changeset(branch_transaction, attrs) do
    branch_transaction
    |> cast(attrs, [:source_branch_id, :receipient_branch_id, :currency_code, :transaction_amount, :transaction_date, :details])
    |> validate_required([:source_branch_id, :receipient_branch_id, :currency_code, :transaction_amount, :transaction_date, :details])
  end
end
