defmodule LoanSystem.Account.AppUser do
  use Ecto.Schema
  import Ecto.Changeset

  schema "appusers" do
    field :mobile_number, :string
    field :password, :string
    field :staff_id, :integer
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(app_user, attrs) do
    app_user
    |> cast(attrs, [:staff_id, :mobile_number, :password, :status])
    |> validate_required([:staff_id, :mobile_number, :password, :status])
  end
end
