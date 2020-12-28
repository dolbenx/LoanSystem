defmodule LoanSystem.Settings.Bank do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_banks" do
    field :code, :string
    field :name, :string
    field :password, :string
    field :url, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(bank, attrs) do
    bank
    |> cast(attrs, [:name, :code, :url, :username, :password])
    |> validate_required([:name, :code, :url, :username, :password])
  end
end
