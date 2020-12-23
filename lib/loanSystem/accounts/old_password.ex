defmodule LoanSystem.Accounts.Old_password do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_old_password" do
    field :date_created, :string
    field :email, :string
    field :password, :string
    belongs_to :user, LoanSystem.Accounts.User, foreign_key: :user_id, type: :id

    timestamps()
  end

  @doc false
  def changeset(old_password, attrs) do
    old_password
    |> cast(attrs, [:date_created, :email, :password])
    |> validate_required([:date_created, :email, :password])
  end
end
