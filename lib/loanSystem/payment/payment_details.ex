defmodule LoanSystem.Payment.PaymentDetails do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_payment_details" do
    field :account_number, :string
    field :bank_number, :string
    field :cheque_number, :string
    field :credit_gl_account_id, :integer
    field :debit_gl_account_id, :integer
    field :payment_type_id, :integer
    field :receipt_number, :string
    field :routing_code, :string

    timestamps()
  end

  @doc false
  def changeset(payment_details, attrs) do
    payment_details
    |> cast(attrs, [:payment_type_id, :account_number, :cheque_number, :receipt_number, :bank_number, :routing_code, :debit_gl_account_id, :credit_gl_account_id])
    |> validate_required([:payment_type_id, :account_number, :cheque_number, :receipt_number, :bank_number, :routing_code, :debit_gl_account_id, :credit_gl_account_id])
  end
end
