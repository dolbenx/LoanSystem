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
<<<<<<< HEAD
<<<<<<< HEAD
    field :status, :boolean, default: true
=======
    field :company_file_name, :string
>>>>>>> DAVIES
=======
    field :company_file_name, :string
>>>>>>> cf39f003d321ff7eeadef8df13be6bfc6cfdd371

    timestamps()
  end

  @doc false
  def changeset(company, attrs) do
    company
<<<<<<< HEAD
<<<<<<< HEAD
    |> cast(attrs, [:email, :phone, :company_name, :tpin_no, :city, :country, :date_of_incorporation, :company_id, :address, :status])
    |> validate_required([:email, :phone, :company_name, :tpin_no, :city, :country, :date_of_incorporation, :company_id, :address])
=======
    |> cast(attrs, [:email, :phone, :company_name, :tpin_no, :city, :country, :date_of_incorporation, :company_id, :address, :company_file_name])
    |> validate_required([:email, :phone, :company_name, :tpin_no, :city, :country, :date_of_incorporation, :company_id, :address, :company_file_name])
>>>>>>> DAVIES
=======
    |> cast(attrs, [:email, :phone, :company_name, :tpin_no, :city, :country, :date_of_incorporation, :company_id, :address, :company_file_name])
    |> validate_required([:email, :phone, :company_name, :tpin_no, :city, :country, :date_of_incorporation, :company_id, :address, :company_file_name])
>>>>>>> cf39f003d321ff7eeadef8df13be6bfc6cfdd371
  end
end
