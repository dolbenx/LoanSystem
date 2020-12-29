defmodule LoanSystem.Loan.USSDLoanProduct do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ussdloanproducts" do
    field :default_interest_rate, :float
    field :default_period, :integer
    field :loan_product_id, :integer
    field :repayment_count, :integer

    timestamps()
  end

  @doc false
  def changeset(ussd_loan_product, attrs) do
    ussd_loan_product
    |> cast(attrs, [:loan_product_id, :default_interest_rate, :default_period, :repayment_count])
    |> validate_required([:loan_product_id, :default_interest_rate, :default_period, :repayment_count])
  end
end
