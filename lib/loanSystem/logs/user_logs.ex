defmodule LoanSystem.Logs.UserLogs do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_user_logs" do
    field :activity, :string
    field :user_id, :string

    timestamps()
  end

  @doc false
  def changeset(user_logs, attrs) do
    user_logs
    |> cast(attrs, [:activity, :user_id])
    |> validate_required([:activity, :user_id])
  end
end
