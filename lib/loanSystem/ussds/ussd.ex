defmodule LoanSystem.Ussds.Ussd do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ussds" do

    timestamps()
  end

  @doc false
  def changeset(ussd, attrs) do
    ussd
    |> cast(attrs, [])
    |> validate_required([])
  end
end
