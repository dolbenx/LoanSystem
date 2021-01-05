defmodule LoanSystem.Loan.LoanProduct do
  use Ecto.Schema
  import Ecto.Changeset

  schema "loanproducts" do
    field :arrearstolerance_amount, :float
    field :close_date, :date
    field :currency_code, :string
    field :days_in_month, :integer
    field :days_in_year, :integer
    field :description, :string
    field :external_id, :string
    field :interest_method_type, :string
    field :max_loan_period, :integer
    field :max_nominal_interest_rate_per_period, :integer
    field :max_number_of_repayments, :integer
    field :max_outstanding_loan_balance, :float
    field :max_principal_amount, :float
    field :min_loan_period, :integer
    field :min_nominal_interest_rate_per_period, :integer
    field :min_number_of_repayments, :integer
    field :min_principal_amount, :float
    field :name, :string
    field :overdue_days_for_npa, :integer
    field :require_collateral, :boolean, default: false
    field :short_code, :string
    field :start_date, :date

    timestamps()
  end

  @doc false
  def changeset(loan_product, attrs) do
    loan_product
    |> cast(attrs, [:short_code, :name, :currency_code, :min_principal_amount, :max_principal_amount, :arrearstolerance_amount, :description, :min_nominal_interest_rate_per_period, :max_nominal_interest_rate_per_period, :min_loan_period, :max_loan_period, :interest_method_type, :min_number_of_repayments, :max_number_of_repayments, :start_date, :close_date, :days_in_month, :days_in_year, :external_id, :overdue_days_for_npa, :max_outstanding_loan_balance, :require_collateral])
    |> validate_required([:short_code, :name, :currency_code, :min_principal_amount, :max_principal_amount, :arrearstolerance_amount, :description, :min_nominal_interest_rate_per_period, :max_nominal_interest_rate_per_period, :min_loan_period, :max_loan_period, :interest_method_type, :min_number_of_repayments, :max_number_of_repayments, :start_date, :close_date, :days_in_month, :days_in_year, :external_id, :overdue_days_for_npa, :max_outstanding_loan_balance, :require_collateral])
  end
end
