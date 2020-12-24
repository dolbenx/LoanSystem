defmodule LoanSystem.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_products" do
    field :annual_interest, :string
    field :code, :string
    field :currency, :string
    field :currency_decimals, :string
    field :days_to_dormancy, :string
    field :days_to_inactive, :string
    field :deposit_fee_amount, :string
    field :details, :string
    field :fixed_period_days, :string
    field :min_balance_required, :string
    field :name, :string
    field :withdrawal_fee_amount, :string
    field :withdrawal_fee_transfer_to_mobile, :string
    field :year_length_days, :string
    field :status, :boolean, default: true

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :code, :details, :currency, :currency_decimals, :annual_interest, :fixed_period_days, :year_length_days, :min_balance_required, :withdrawal_fee_amount, :withdrawal_fee_transfer_to_mobile, :deposit_fee_amount, :days_to_inactive, :days_to_dormancy, :status])
    |> validate_required([:name, :code, :details, :currency, :currency_decimals, :annual_interest, :fixed_period_days, :year_length_days, :min_balance_required, :withdrawal_fee_amount, :withdrawal_fee_transfer_to_mobile, :deposit_fee_amount, :days_to_inactive, :days_to_dormancy])
  end
end
