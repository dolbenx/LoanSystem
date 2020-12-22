defmodule LoanSystem.Companies do
  @moduledoc """
  The Companies context.
  """

  import Ecto.Query, warn: false
  alias LoanSystem.Repo

  alias LoanSystem.Companies.Stuff

  @doc """
  Returns the list of tbl_stuff.

  ## Examples

      iex> list_tbl_stuff()
      [%Stuff{}, ...]

  """
  def list_tbl_stuff do
    Repo.all(Stuff)
  end

  @doc """
  Gets a single stuff.

  Raises `Ecto.NoResultsError` if the Stuff does not exist.

  ## Examples

      iex> get_stuff!(123)
      %Stuff{}

      iex> get_stuff!(456)
      ** (Ecto.NoResultsError)

  """
  def get_stuff!(id), do: Repo.get!(Stuff, id)

  @doc """
  Creates a stuff.

  ## Examples

      iex> create_stuff(%{field: value})
      {:ok, %Stuff{}}

      iex> create_stuff(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_stuff(attrs \\ %{}) do
    %Stuff{}
    |> Stuff.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a stuff.

  ## Examples

      iex> update_stuff(stuff, %{field: new_value})
      {:ok, %Stuff{}}

      iex> update_stuff(stuff, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_stuff(%Stuff{} = stuff, attrs) do
    stuff
    |> Stuff.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a stuff.

  ## Examples

      iex> delete_stuff(stuff)
      {:ok, %Stuff{}}

      iex> delete_stuff(stuff)
      {:error, %Ecto.Changeset{}}

  """
  def delete_stuff(%Stuff{} = stuff) do
    Repo.delete(stuff)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking stuff changes.

  ## Examples

      iex> change_stuff(stuff)
      %Ecto.Changeset{source: %Stuff{}}

  """
  def change_stuff(%Stuff{} = stuff) do
    Stuff.changeset(stuff, %{})
  end

  alias LoanSystem.Companies.Company

  @doc """
  Returns the list of tbl_companies.

  ## Examples

      iex> list_tbl_companies()
      [%Company{}, ...]

  """
  def list_tbl_companies do
    Repo.all(Company)
  end

  @doc """
  Gets a single company.

  Raises `Ecto.NoResultsError` if the Company does not exist.

  ## Examples

      iex> get_company!(123)
      %Company{}

      iex> get_company!(456)
      ** (Ecto.NoResultsError)

  """
  def get_company!(id), do: Repo.get!(Company, id)

  @doc """
  Creates a company.

  ## Examples

      iex> create_company(%{field: value})
      {:ok, %Company{}}

      iex> create_company(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_company(attrs \\ %{}) do
    %Company{}
    |> Company.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a company.

  ## Examples

      iex> update_company(company, %{field: new_value})
      {:ok, %Company{}}

      iex> update_company(company, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_company(%Company{} = company, attrs) do
    company
    |> Company.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a company.

  ## Examples

      iex> delete_company(company)
      {:ok, %Company{}}

      iex> delete_company(company)
      {:error, %Ecto.Changeset{}}

  """
  def delete_company(%Company{} = company) do
    Repo.delete(company)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking company changes.

  ## Examples

      iex> change_company(company)
      %Ecto.Changeset{source: %Company{}}

  """
  def change_company(%Company{} = company) do
    Company.changeset(company, %{})
  end
end
