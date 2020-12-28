defmodule LoanSystem.Accounts.UserRoles do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_user_role" do
    field :created_by, :string
    field :role_description, :string
    field :role_name, :string
   # field :user_id, :string

    belongs_to :user, LoanSystem.Accounts.User, foreign_key: :user_id, type: :id
    timestamps(type: :utc_datetime)

  end
  @spec changeset(
    {map, map} | %{:__struct__ => atom | %{__changeset__: map}, optional(atom) => any},
    :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
  ) :: Ecto.Changeset.t()
@doc false
def changeset(user_roles, attrs) do
user_roles
|> cast(attrs, [:user_id, :role_name, :role_description, :created_by])
|> validate_required([:user_id, :role_name, :role_description, :created_by])
end

end
