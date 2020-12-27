defmodule LoanSystem.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias LoanSystem.Repo

  alias LoanSystem.Accounts.Old_password

  @doc """
  Returns the list of tbl_old_password.

  ## Examples

      iex> list_tbl_old_password()
      [%Old_password{}, ...]

  """
  def list_tbl_old_password do
    Repo.all(Old_password)
  end

  @doc """
  Gets a single old_password.

  Raises `Ecto.NoResultsError` if the Old password does not exist.

  ## Examples

      iex> get_old_password!(123)
      %Old_password{}

      iex> get_old_password!(456)
      ** (Ecto.NoResultsError)

  """
  def get_old_password!(id), do: Repo.get!(Old_password, id)

  def check_old_password(id, date) do
    Repo.all(from u in Old_password, where: u.user_id == ^id and u.date_created >= ^date)
  end
  @doc """
  Creates a old_password.

  ## Examples

      iex> create_old_password(%{field: value})
      {:ok, %Old_password{}}

      iex> create_old_password(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_old_password(attrs \\ %{}) do
    %Old_password{}
    |> Old_password.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a old_password.

  ## Examples

      iex> update_old_password(old_password, %{field: new_value})
      {:ok, %Old_password{}}

      iex> update_old_password(old_password, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_old_password(%Old_password{} = old_password, attrs) do
    old_password
    |> Old_password.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a old_password.

  ## Examples

      iex> delete_old_password(old_password)
      {:ok, %Old_password{}}

      iex> delete_old_password(old_password)
      {:error, %Ecto.Changeset{}}

  """
  def delete_old_password(%Old_password{} = old_password) do
    Repo.delete(old_password)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking old_password changes.

  ## Examples

      iex> change_old_password(old_password)
      %Ecto.Changeset{source: %Old_password{}}

  """
  def change_old_password(%Old_password{} = old_password) do
    Old_password.changeset(old_password, %{})
  end

  alias LoanSystem.Accounts.User

  @doc """
  Returns the list of tbl_users.

  ## Examples

      iex> list_tbl_users()
      [%User{}, ...]

  """
  def list_tbl_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  alias LoanSystem.Accounts.UserRoles

  @doc """
  Returns the list of tbl_user_role.

  ## Examples

      iex> list_tbl_user_role()
      [%UserRoles{}, ...]

  """
  def list_tbl_user_role do
    Repo.all(UserRoles)
  end

  @doc """
  Gets a single user_roles.

  Raises `Ecto.NoResultsError` if the User roles does not exist.

  ## Examples

      iex> get_user_roles!(123)
      %UserRoles{}

      iex> get_user_roles!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_roles!(id), do: Repo.get!(UserRoles, id)

  @doc """
  Creates a user_roles.

  ## Examples

      iex> create_user_roles(%{field: value})
      {:ok, %UserRoles{}}

      iex> create_user_roles(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_roles(attrs \\ %{}) do
    %UserRoles{}
    |> UserRoles.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user_roles.

  ## Examples

      iex> update_user_roles(user_roles, %{field: new_value})
      {:ok, %UserRoles{}}

      iex> update_user_roles(user_roles, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_roles(%UserRoles{} = user_roles, attrs) do
    user_roles
    |> UserRoles.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user_roles.

  ## Examples

      iex> delete_user_roles(user_roles)
      {:ok, %UserRoles{}}

      iex> delete_user_roles(user_roles)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_roles(%UserRoles{} = user_roles) do
    Repo.delete(user_roles)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_roles changes.

  ## Examples

      iex> change_user_roles(user_roles)
      %Ecto.Changeset{source: %UserRoles{}}

  """
  def change_user_roles(%UserRoles{} = user_roles) do
    UserRoles.changeset(user_roles, %{})
  end
end
