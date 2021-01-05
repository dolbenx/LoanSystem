defmodule LoanSystem.Loan.Loans do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_loans" do
    field :principal_repaid_derived, :float
    field :number_of_repayments, :integer
    field :withdrawnon_date, :date
    field :currency_code, :string
    field :is_npa, :boolean, default: false
    field :repay_every_type, :string
    field :principal_writtenoff_derived, :float
    field :disbursedon_userid, :integer
    field :approvedon_userid, :integer
    field :total_writtenoff_derived, :float
    field :repay_every, :integer
    field :closedon_userid, :integer
    field :product_id, :integer
    field :customer_id, :integer
    field :interest_method, :string
    field :annual_nominal_interest_rate, :float
    field :writtenoffon_date, :date
    field :total_outstanding_derived, :float
    field :interest_calculated_from_date, :date
    field :loan_counter, :integer
    field :interest_charged_derived, :float
    field :term_frequency_type, :string
    field :total_charges_due_at_disbursement_derived, :float
    field :penalty_charges_waived_derived, :float
    field :total_overpaid_derived, :float
    field :approved_principal, :float
    field :principal_disbursed_derived, :float
    field :rejectedon_userid, :integer
    field :approvedon_date, :date
    field :loan_type, :string
    field :principal_amount, :float
    field :disbursedon_date, :date
    field :account_no, :string
    field :interest_outstanding_derived, :float
    field :interest_writtenoff_derived, :float
    field :penalty_charges_writtenoff_derived, :float
    field :loan_status, :string
    field :fee_charges_charged_derived, :float
    field :fee_charges_waived_derived, :float
    field :interest_waived_derived, :float
    field :total_costofloan_derived, :float
    field :principal_amount_proposed, :float
    field :fee_charges_repaid_derived, :float
    field :total_expected_repayment_derived, :float
    field :principal_outstanding_derived, :float
    field :penalty_charges_charged_derived, :float
    field :is_legacyloan, :boolean, default: false
    field :total_waived_derived, :float
    field :interest_repaid_derived, :float
    field :rejectedon_date, :date
    field :fee_charges_outstanding_derived, :float
    field :expected_disbursedon_date, :date
    field :closedon_date, :date
    field :fee_charges_writtenoff_derived, :float
    field :penalty_charges_outstanding_derived, :float
    field :total_expected_costofloan_derived, :float
    field :penalty_charges_repaid_derived, :float
    field :withdrawnon_userid, :integer
    field :expected_maturity_date, :date
    field :external_id, :string
    field :term_frequency, :integer
    field :total_repayment_derived, :float
    field :loan_identity_number, :string
    field :branch_id, :integer
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(loans, attrs) do
    loans
    |> cast(attrs, [:branch_id, :loan_identity_number, :account_no, :external_id, :customer_id, :product_id, :loan_status, :loan_type, :currency_code, :principal_amount_proposed, :principal_amount, :approved_principal, :annual_nominal_interest_rate, :interest_method, :term_frequency, :term_frequency_type, :repay_every, :repay_every_type, :number_of_repayments, :approvedon_date, :approvedon_userid, :expected_disbursedon_date, :disbursedon_date, :disbursedon_userid, :expected_maturity_date, :interest_calculated_from_date, :closedon_date, :closedon_userid, :total_charges_due_at_disbursement_derived, :principal_disbursed_derived, :principal_repaid_derived, :principal_writtenoff_derived, :principal_outstanding_derived, :interest_charged_derived, :interest_repaid_derived, :interest_waived_derived, :interest_writtenoff_derived, :interest_outstanding_derived, :fee_charges_charged_derived, :fee_charges_repaid_derived, :fee_charges_waived_derived, :fee_charges_writtenoff_derived, :fee_charges_outstanding_derived, :penalty_charges_charged_derived, :penalty_charges_repaid_derived, :penalty_charges_waived_derived, :penalty_charges_writtenoff_derived, :penalty_charges_outstanding_derived, :total_expected_repayment_derived, :total_repayment_derived, :total_expected_costofloan_derived, :total_costofloan_derived, :total_waived_derived, :total_writtenoff_derived, :total_outstanding_derived, :total_overpaid_derived, :rejectedon_date, :rejectedon_userid, :withdrawnon_date, :withdrawnon_userid, :writtenoffon_date, :loan_counter, :is_npa, :is_legacyloan, :status])
    |> validate_required([:branch_id, :loan_identity_number, :account_no, :external_id, :customer_id, :product_id, :loan_status, :loan_type, :currency_code, :principal_amount_proposed, :principal_amount, :approved_principal, :annual_nominal_interest_rate, :interest_method, :term_frequency, :term_frequency_type, :repay_every, :repay_every_type, :number_of_repayments, :approvedon_date, :approvedon_userid, :expected_disbursedon_date, :disbursedon_date, :disbursedon_userid, :expected_maturity_date, :interest_calculated_from_date, :closedon_date, :closedon_userid, :total_charges_due_at_disbursement_derived, :principal_disbursed_derived, :principal_repaid_derived, :principal_writtenoff_derived, :principal_outstanding_derived, :interest_charged_derived, :interest_repaid_derived, :interest_waived_derived, :interest_writtenoff_derived, :interest_outstanding_derived, :fee_charges_charged_derived, :fee_charges_repaid_derived, :fee_charges_waived_derived, :fee_charges_writtenoff_derived, :fee_charges_outstanding_derived, :penalty_charges_charged_derived, :penalty_charges_repaid_derived, :penalty_charges_waived_derived, :penalty_charges_writtenoff_derived, :penalty_charges_outstanding_derived, :total_expected_repayment_derived, :total_repayment_derived, :total_expected_costofloan_derived, :total_costofloan_derived, :total_waived_derived, :total_writtenoff_derived, :total_outstanding_derived, :total_overpaid_derived, :rejectedon_date, :rejectedon_userid, :withdrawnon_date, :withdrawnon_userid, :writtenoffon_date, :loan_counter, :is_npa, :is_legacyloan, :status])
  end
end
