defmodule LoanSystem.Settings.SystemParams do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_system_params" do

    field :name, :string
    field :pacra_num, :string
    field :address, :string
    field :phone, :string
    field :logo, :string

    timestamps()
  end

  @doc false
  def changeset(system_params, attrs) do
    system_params
    |> cast(attrs, [:name, :pacra_num, :address, :phone, :logo])
    |> validate_required([:name, :pacra_num, :address, :phone])
  end
end
