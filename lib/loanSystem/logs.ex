defmodule LoanSystem.Logs do
  @moduledoc """
  The Logs context.
  """

  import Ecto.Query, warn: false
  alias LoanSystem.Repo

  alias LoanSystem.Logs.UserLogs

  @doc """
  Returns the list of tbl_user_logs.

  ## Examples

      iex> list_tbl_user_logs()
      [%UserLogs{}, ...]

  """
  def list_tbl_user_logs do
    Repo.all(UserLogs)
  end

  def last_logged_in (log) do
    Repo.all(
      from(
        u in UserLogs,
        where: u.activity == "logged in" and u.user_id == ^log,
        select: u,
        order_by: [desc: u.inserted_at],
        limit: 2
      )
    )
  end

  @doc """
  Gets a single user_logs.

  Raises `Ecto.NoResultsError` if the User logs does not exist.

  ## Examples

      iex> get_user_logs!(123)
      %UserLogs{}

      iex> get_user_logs!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_logs!(id), do: Repo.get!(UserLogs, id)

  @doc """
  Creates a user_logs.

  ## Examples

      iex> create_user_logs(%{field: value})
      {:ok, %UserLogs{}}

      iex> create_user_logs(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_logs(attrs \\ %{}) do
    %UserLogs{}
    |> UserLogs.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user_logs.

  ## Examples

      iex> update_user_logs(user_logs, %{field: new_value})
      {:ok, %UserLogs{}}

      iex> update_user_logs(user_logs, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_logs(%UserLogs{} = user_logs, attrs) do
    user_logs
    |> UserLogs.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user_logs.

  ## Examples

      iex> delete_user_logs(user_logs)
      {:ok, %UserLogs{}}

      iex> delete_user_logs(user_logs)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_logs(%UserLogs{} = user_logs) do
    Repo.delete(user_logs)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_logs changes.

  ## Examples

      iex> change_user_logs(user_logs)
      %Ecto.Changeset{source: %UserLogs{}}

  """
  def change_user_logs(%UserLogs{} = user_logs) do
    UserLogs.changeset(user_logs, %{})
  end
end
