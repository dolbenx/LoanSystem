defmodule LoanSystem.Repo.Migrations.CreateTblSystemParams do
  use Ecto.Migration

  def change do
    create table(:tbl_system_params) do
      add :name, :string
      add :code, :string
      add :url, :string
      add :username, :string
      add :password, :string

      timestamps()
    end

  end
end
