defmodule LoanSystem.Ussds do
  @moduledoc """
  The Ussds context.
  """

  import Ecto.Query, warn: false
  alias LoanSystem.Repo

  alias LoanSystem.Ussds.Ussd

  @doc """
  Returns the list of ussds.

  ## Examples

      iex> list_ussds()
      [%Ussd{}, ...]

  """
  def list_ussds do
    Repo.all(Ussd)
  end

  @doc """
  Gets a single ussd.

  Raises `Ecto.NoResultsError` if the Ussd does not exist.

  ## Examples

      iex> get_ussd!(123)
      %Ussd{}

      iex> get_ussd!(456)
      ** (Ecto.NoResultsError)

  """
  def get_ussd!(id), do: Repo.get!(Ussd, id)

  @doc """
  Creates a ussd.

  ## Examples

      iex> create_ussd(%{field: value})
      {:ok, %Ussd{}}

      iex> create_ussd(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_ussd(attrs \\ %{}) do
    %Ussd{}
    |> Ussd.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a ussd.

  ## Examples

      iex> update_ussd(ussd, %{field: new_value})
      {:ok, %Ussd{}}

      iex> update_ussd(ussd, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_ussd(%Ussd{} = ussd, attrs) do
    ussd
    |> Ussd.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ussd.

  ## Examples

      iex> delete_ussd(ussd)
      {:ok, %Ussd{}}

      iex> delete_ussd(ussd)
      {:error, %Ecto.Changeset{}}

  """
  def delete_ussd(%Ussd{} = ussd) do
    Repo.delete(ussd)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking ussd changes.

  ## Examples

      iex> change_ussd(ussd)
      %Ecto.Changeset{source: %Ussd{}}

  """
  def change_ussd(%Ussd{} = ussd) do
    Ussd.changeset(ussd, %{})
  end
end
