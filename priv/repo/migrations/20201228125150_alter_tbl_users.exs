defmodule LoanSystem.Repo.Migrations.AlterTblUsers do
  use Ecto.Migration

  def change do
    alter table(:tbl_users) do
      add :home_add, :string
      add :user_id, :integer
    end
  end
end
