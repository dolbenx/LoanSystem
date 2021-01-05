defmodule LoanSystem.Companies.Company do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_companies" do
    field :address, :string
    field :city, :string
    field :company_id, :string
    field :company_name, :string
    field :country, :string
    field :date_of_incorporation, :string
    field :email, :string
    field :phone, :string
    field :tpin_no, :string
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, [:email, :phone, :company_name, :tpin_no, :city, :country, :date_of_incorporation, :company_id, :address])
    |> validate_required([:email, :phone, :company_name, :tpin_no, :city, :country, :date_of_incorporation, :company_id, :address])
  end
end
