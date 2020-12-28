defmodule LoanSystem.Branch.Branchs do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_branchs" do
    field :branch_address, :string
    field :branch_district, :string
    field :branch_name, :string
    field :branch_province, :string
    field :opening_date, :date
    field :parent_branch_id, :integer

    timestamps()
  end

  @doc false
  def changeset(branchs, attrs) do
    branchs
    |> cast(attrs, [:branch_name, :branch_address, :branch_province, :branch_district, :parent_branch_id, :opening_date])
    |> validate_required([:branch_name, :branch_address, :branch_province, :branch_district, :parent_branch_id, :opening_date])
  end
end
