defmodule LoanSystem.Repo.Migrations.AlterTblCompany do
  use Ecto.Migration

  def change do
    alter table(:tbl_companies) do
      add :company_file_name, :string
  end
end
end
