defmodule LoanSystem.Settings.Mno do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_mnos" do
    field :code, :string
    field :name, :string
    field :password, :string
    field :url, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(mno, attrs) do
    mno
    |> cast(attrs, [:name, :code, :url, :username, :password])
    |> validate_required([:name, :code, :url, :username, :password])
  end
end
