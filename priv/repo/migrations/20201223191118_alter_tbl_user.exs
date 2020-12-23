defmodule LoanSystem.Repo.Migrations.AlterTblUser do
  use Ecto.Migration

  def change do
    alter table(:tbl_users) do
      add :loan_officer, :boolean
    end
  end
end
