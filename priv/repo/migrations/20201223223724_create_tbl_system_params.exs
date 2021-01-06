defmodule LoanSystem.Repo.Migrations.CreateTblSystemParams do
  use Ecto.Migration

  def change do
    create table(:tbl_system_params) do
      add :name, :string
      add :pacra_num, :string
      add :address, :string
      add :phone, :string


      timestamps()
    end
    execute """
    ALTER TABLE tbl_system_params
    ADD logo VARCHAR(MAX);
    """

  end
end
