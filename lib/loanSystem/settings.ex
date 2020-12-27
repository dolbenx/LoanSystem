defmodule LoanSystem.Settings do
  @moduledoc """
  The Settings context.
  """

  import Ecto.Query, warn: false
  alias LoanSystem.Repo

  alias LoanSystem.Settings.SystemParams

  @doc """
  Returns the list of tbl_system_params.

  ## Examples

      iex> list_tbl_system_params()
      [%SystemParams{}, ...]

  """
  def list_tbl_system_params do
    Repo.all(SystemParams)
  end

  @doc """
  Gets a single system_params.

  Raises `Ecto.NoResultsError` if the System params does not exist.

  ## Examples

      iex> get_system_params!(123)
      %SystemParams{}

      iex> get_system_params!(456)
      ** (Ecto.NoResultsError)

  """
  def get_system_params!(id), do: Repo.get!(SystemParams, id)

  @doc """
  Creates a system_params.

  ## Examples

      iex> create_system_params(%{field: value})
      {:ok, %SystemParams{}}

      iex> create_system_params(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_system_params(attrs \\ %{}) do
    %SystemParams{}
    |> SystemParams.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a system_params.

  ## Examples

      iex> update_system_params(system_params, %{field: new_value})
      {:ok, %SystemParams{}}

      iex> update_system_params(system_params, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_system_params(%SystemParams{} = system_params, attrs) do
    system_params
    |> SystemParams.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a system_params.

  ## Examples

      iex> delete_system_params(system_params)
      {:ok, %SystemParams{}}

      iex> delete_system_params(system_params)
      {:error, %Ecto.Changeset{}}

  """
  def delete_system_params(%SystemParams{} = system_params) do
    Repo.delete(system_params)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking system_params changes.

  ## Examples

      iex> change_system_params(system_params)
      %Ecto.Changeset{source: %SystemParams{}}

  """
  def change_system_params(%SystemParams{} = system_params) do
    SystemParams.changeset(system_params, %{})
  end

  alias LoanSystem.Settings.Bank

  @doc """
  Returns the list of tbl_banks.

  ## Examples

      iex> list_tbl_banks()
      [%Bank{}, ...]

  """
  def list_tbl_banks do
    Repo.all(Bank)
  end

  @doc """
  Gets a single bank.

  Raises `Ecto.NoResultsError` if the Bank does not exist.

  ## Examples

      iex> get_bank!(123)
      %Bank{}

      iex> get_bank!(456)
      ** (Ecto.NoResultsError)

  """
  def get_bank!(id), do: Repo.get!(Bank, id)

  @doc """
  Creates a bank.

  ## Examples

      iex> create_bank(%{field: value})
      {:ok, %Bank{}}

      iex> create_bank(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_bank(attrs \\ %{}) do
    %Bank{}
    |> Bank.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a bank.

  ## Examples

      iex> update_bank(bank, %{field: new_value})
      {:ok, %Bank{}}

      iex> update_bank(bank, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_bank(%Bank{} = bank, attrs) do
    bank
    |> Bank.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a bank.

  ## Examples

      iex> delete_bank(bank)
      {:ok, %Bank{}}

      iex> delete_bank(bank)
      {:error, %Ecto.Changeset{}}

  """
  def delete_bank(%Bank{} = bank) do
    Repo.delete(bank)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking bank changes.

  ## Examples

      iex> change_bank(bank)
      %Ecto.Changeset{source: %Bank{}}

  """
  def change_bank(%Bank{} = bank) do
    Bank.changeset(bank, %{})
  end

  alias LoanSystem.Settings.Mno

  @doc """
  Returns the list of tbl_mnos.

  ## Examples

      iex> list_tbl_mnos()
      [%Mno{}, ...]

  """
  def list_tbl_mnos do
    Repo.all(Mno)
  end

  @doc """
  Gets a single mno.

  Raises `Ecto.NoResultsError` if the Mno does not exist.

  ## Examples

      iex> get_mno!(123)
      %Mno{}

      iex> get_mno!(456)
      ** (Ecto.NoResultsError)

  """
  def get_mno!(id), do: Repo.get!(Mno, id)

  @doc """
  Creates a mno.

  ## Examples

      iex> create_mno(%{field: value})
      {:ok, %Mno{}}

      iex> create_mno(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_mno(attrs \\ %{}) do
    %Mno{}
    |> Mno.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a mno.

  ## Examples

      iex> update_mno(mno, %{field: new_value})
      {:ok, %Mno{}}

      iex> update_mno(mno, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_mno(%Mno{} = mno, attrs) do
    mno
    |> Mno.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a mno.

  ## Examples

      iex> delete_mno(mno)
      {:ok, %Mno{}}

      iex> delete_mno(mno)
      {:error, %Ecto.Changeset{}}

  """
  def delete_mno(%Mno{} = mno) do
    Repo.delete(mno)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking mno changes.

  ## Examples

      iex> change_mno(mno)
      %Ecto.Changeset{source: %Mno{}}

  """
  def change_mno(%Mno{} = mno) do
    Mno.changeset(mno, %{})
  end
end
