defmodule LoanSystem.Repo.Migrations.CreateTblStuff do
  use Ecto.Migration

  def change do
    create table(:tbl_stuff) do
      add :first_name, :string
      add :last_name, :string
      add :other_name, :string
      add :email, :string
      add :phone, :string
      add :company_name, :string
      add :tpin_no, :string
      add :city, :string
      add :country, :string
      add :company_id, :string
      add :address, :string
      add :id_no, :string
      add :id_type, :string

      timestamps()
    end

  end
end
