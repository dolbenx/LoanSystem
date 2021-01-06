defmodule LoanSystem.Repo.Migrations.AlterTblStatus do
  use Ecto.Migration

  def change do
      alter table(:tbl_loans) do
        add :status, :string
      end
    end
end
