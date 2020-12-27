defmodule LoanSystem.Settings.SystemParams do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_system_params" do
    field :code, :string
    field :name, :string
    field :password, :string
    field :url, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(system_params, attrs) do
    system_params
    |> cast(attrs, [:name, :code, :url, :username, :password])
    |> validate_required([:name, :code, :url, :username, :password])
  end
end
