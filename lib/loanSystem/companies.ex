defmodule LoanSystem.Companies do
  @moduledoc """
  The Companies context.
  """

  import Ecto.Query, warn: false
  alias LoanSystem.Repo
  alias LoanSystem.Companies.Staff
  alias LoanSystem.Companies.Company

  @doc """
  Returns the list of tbl_companies.
  ## Examples
   """
  def list_tbl_companies do
    Repo.all(Company)
  end

  def list_tbl_staff do
    Repo.all(Staff)
  end

  def comp_id(company_id) do
    Company
    |> where([a], a.company_id == ^company_id)
    |> select(
      [a],
      map(a, [:company_id, :company_id, :company_name])
    )
    |> Repo.one()
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

  alias LoanSystem.Companies.Staff

  @doc """
  Returns the list of tbl_staff.
  ## Examples
      iex> list_tbl_staff()
      [%Staff{}, ...]
  """
  def list_tbl_staff do
    Repo.all(Staff)
  end

  def list_stuff_with_company_id(company_id) do
    Company
    |> join(:left, [c], s in "tbl_staff", on: c.company_id == s.company_id)
    |> where([c, s], c.company_id == ^company_id)
    |> select([c, s], %{
      company_name: c.company_name,
      first_name: s.first_name,
      last_name: s.last_name,
      id: s.id,
      company_id: s.company_id,
      country: s.country,
      city: s.city,
      other_name: s.other_name,
      email: s.email,
      phone: s.phone,
      address: s.address,
      id_no: s.id_no,
      id_type: s.id_type,
      tpin_no: s.tpin_no
    })
    |> Repo.all()
  end
  @doc """
  Gets a single staff.
  Raises `Ecto.NoResultsError` if the Staff does not exist.
  ## Examples
      iex> get_staff!(123)
      %Staff{}
      iex> get_staff!(456)
      ** (Ecto.NoResultsError)
  """
  def get_staff!(id), do: Repo.get!(Staff, id)

  @doc """
  Creates a staff.
  ## Examples
      iex> create_staff(%{field: value})
      {:ok, %Staff{}}
      iex> create_staff(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def create_staff(attrs \\ %{}) do
    %Staff{}
    |> Staff.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a staff.
  ## Examples
      iex> update_staff(staff, %{field: new_value})
      {:ok, %Staff{}}
      iex> update_staff(staff, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def update_staff(%Staff{} = staff, attrs) do
    staff
    |> Staff.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a staff.
  ## Examples
      iex> delete_staff(staff)
      {:ok, %Staff{}}
      iex> delete_staff(staff)
      {:error, %Ecto.Changeset{}}
  """
  def delete_staff(%Staff{} = staff) do
    Repo.delete(staff)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking staff changes.
  ## Examples
      iex> change_staff(staff)
      %Ecto.Changeset{source: %Staff{}}
  """
  def change_staff(%Staff{} = staff) do
    Staff.changeset(staff, %{})
  end
end
