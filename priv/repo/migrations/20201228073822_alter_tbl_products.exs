defmodule LoanSystem.Repo.Migrations.AlterTblProducts do
  use Ecto.Migration

  def change do
    alter table(:tbl_products) do
      add :status, :string
    end
  end
end
