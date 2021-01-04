defmodule LoanSystem.Companies.Staff do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_staff" do
    field :address, :string
    field :city, :string
    field :company_id, :string
    field :gender, :string
    field :country, :string
    field :email, :string, null: false
    field :first_name, :string
    field :id_no, :string
    field :id_type, :string
    field :last_name, :string
    field :other_name, :string
    field :phone, :string
    field :status, :string
    field :account_no, :string
    field :branch_id, :integer
    field :staff_file_name, :string
    timestamps()
  end

  @doc false
  def changeset(staff, attrs) do
    staff
    |> cast(attrs, [:first_name, :last_name, :other_name, :email, :phone, :status, :city, :country, :company_id, :address, :id_no, :id_type, :account_no, :branch_id, :staff_file_name, :gender])
    |> validate_required([:first_name, :last_name, :email, :phone, :status, :city, :country, :company_id, :address, :id_no, :id_type, :account_no, :branch_id, :staff_file_name, :gender])
  end
end
