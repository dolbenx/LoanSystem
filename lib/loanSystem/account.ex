defmodule LoanSystem.Account do
  @moduledoc """
  The Account context.
  """

  import Ecto.Query, warn: false
  alias LoanSystem.Repo

  alias LoanSystem.Account.AppUser

  @doc """
  Returns the list of appusers.

  ## Examples

      iex> list_appusers()
      [%AppUser{}, ...]

  """
  def list_appusers do
    Repo.all(AppUser)
  end

  @doc """
  Gets a single app_user.

  Raises `Ecto.NoResultsError` if the App user does not exist.

  ## Examples

      iex> get_app_user!(123)
      %AppUser{}

      iex> get_app_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_app_user!(id), do: Repo.get!(AppUser, id)

  @doc """
  Creates a app_user.

  ## Examples

      iex> create_app_user(%{field: value})
      {:ok, %AppUser{}}

      iex> create_app_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_app_user(attrs \\ %{}) do
    %AppUser{}
    |> AppUser.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a app_user.

  ## Examples

      iex> update_app_user(app_user, %{field: new_value})
      {:ok, %AppUser{}}

      iex> update_app_user(app_user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_app_user(%AppUser{} = app_user, attrs) do
    app_user
    |> AppUser.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a app_user.

  ## Examples

      iex> delete_app_user(app_user)
      {:ok, %AppUser{}}

      iex> delete_app_user(app_user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_app_user(%AppUser{} = app_user) do
    Repo.delete(app_user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking app_user changes.

  ## Examples

      iex> change_app_user(app_user)
      %Ecto.Changeset{source: %AppUser{}}

  """
  def change_app_user(%AppUser{} = app_user) do
    AppUser.changeset(app_user, %{})
  end
end
