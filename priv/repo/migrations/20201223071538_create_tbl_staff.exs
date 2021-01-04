defmodule LoanSystem.Repo.Migrations.CreateTblStaff do
  use Ecto.Migration

  def change do
    create table(:tbl_staff) do
      add :first_name, :string
      add :last_name, :string
      add :other_name, :string
      add :email, :string, null: false
      add :phone, :string
      add :gender, :string
      add :status, :string
      add :city, :string
      add :country, :string
      add :company_id, :string
      add :address, :string
      add :id_no, :string
      add :id_type, :string
      add :account_no, :string
      add :branch_id, :integer
      add :staff_file_name, :string

      timestamps()
    end

  end
end
