defmodule LoanSystem.Loan.Charge do
  use Ecto.Schema
  import Ecto.Changeset

  schema "charges" do
    field :name, :string
    field :type, :string
    field :valuation, :float
    field :applicable_during_disbursement, :boolean, default: false
    field :is_penalty, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(charge, attrs) do
    charge
    |> cast(attrs, [:name, :type, :valuation, :applicable_during_disbursement, :is_penalty])
    |> validate_required([:name, :type, :valuation, :applicable_during_disbursement, :is_penalty])
  end
end
