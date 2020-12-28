defmodule LoanSystem.Repo.Migrations.AlterTblStaff do
  use Ecto.Migration

  def change do
    alter table(:tbl_staff) do
      add :staff_file_name, :string
    end
  end
end
