defmodule LoanSystem.Repo.Migrations.AlterTblOldPassword do
  use Ecto.Migration

  def change do
    alter table(:tbl_old_password) do
      add :user_id, :integer
    end
  end
end
