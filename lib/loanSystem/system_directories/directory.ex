defmodule LoanSystem.SystemDirectories.Directory do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_system_directories" do
    field :auth_status, :string
    field :bulk_trns, :string
    field :errors, :string
    field :esb_complete, :string
    field :esb_download, :string
    field :esb_failed, :string
    field :esb_pending, :string
    field :failed, :string
    field :internet_trns, :string
    field :inwards, :string
    field :modification, :string
    field :outwards, :string
    field :processed, :string
    field :reason, :string

    timestamps()
  end

  @doc false
  def changeset(directory, attrs) do
    directory
    |> cast(attrs, [:failed, :processed, :bulk_trns, :esb_complete, :esb_download, :esb_failed, :esb_pending, :internet_trns, :inwards, :outwards, :errors, :auth_status, :modification, :reason])
    |> validate_required([:failed, :processed])
  end
end
