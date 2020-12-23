defmodule LoanSystem.Branch do
  @moduledoc """
  The Branch context.
  """

  import Ecto.Query, warn: false
  alias LoanSystem.Repo

  alias LoanSystem.Branch.Branchs

  @doc """
  Returns the list of tbl_branchs.

  ## Examples

      iex> list_tbl_branchs()
      [%Branchs{}, ...]

  """
  def list_tbl_branchs do
    Repo.all(Branchs)
  end

  @doc """
  Gets a single branchs.

  Raises `Ecto.NoResultsError` if the Branchs does not exist.

  ## Examples

      iex> get_branchs!(123)
      %Branchs{}

      iex> get_branchs!(456)
      ** (Ecto.NoResultsError)

  """
  def get_branchs!(id), do: Repo.get!(Branchs, id)

  @doc """
  Creates a branchs.

  ## Examples

      iex> create_branchs(%{field: value})
      {:ok, %Branchs{}}

      iex> create_branchs(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_branchs(attrs \\ %{}) do
    %Branchs{}
    |> Branchs.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a branchs.

  ## Examples

      iex> update_branchs(branchs, %{field: new_value})
      {:ok, %Branchs{}}

      iex> update_branchs(branchs, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_branchs(%Branchs{} = branchs, attrs) do
    branchs
    |> Branchs.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a branchs.

  ## Examples

      iex> delete_branchs(branchs)
      {:ok, %Branchs{}}

      iex> delete_branchs(branchs)
      {:error, %Ecto.Changeset{}}

  """
  def delete_branchs(%Branchs{} = branchs) do
    Repo.delete(branchs)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking branchs changes.

  ## Examples

      iex> change_branchs(branchs)
      %Ecto.Changeset{source: %Branchs{}}

  """
  def change_branchs(%Branchs{} = branchs) do
    Branchs.changeset(branchs, %{})
  end

  alias LoanSystem.Branch.BranchTransaction

  @doc """
  Returns the list of tbl_branch_branch_transactions.

  ## Examples

      iex> list_tbl_branch_branch_transactions()
      [%BranchTransaction{}, ...]

  """
  def list_tbl_branch_branch_transactions do
    Repo.all(BranchTransaction)
  end

  @doc """
  Gets a single branch_transaction.

  Raises `Ecto.NoResultsError` if the Branch transaction does not exist.

  ## Examples

      iex> get_branch_transaction!(123)
      %BranchTransaction{}

      iex> get_branch_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_branch_transaction!(id), do: Repo.get!(BranchTransaction, id)

  @doc """
  Creates a branch_transaction.

  ## Examples

      iex> create_branch_transaction(%{field: value})
      {:ok, %BranchTransaction{}}

      iex> create_branch_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_branch_transaction(attrs \\ %{}) do
    %BranchTransaction{}
    |> BranchTransaction.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a branch_transaction.

  ## Examples

      iex> update_branch_transaction(branch_transaction, %{field: new_value})
      {:ok, %BranchTransaction{}}

      iex> update_branch_transaction(branch_transaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_branch_transaction(%BranchTransaction{} = branch_transaction, attrs) do
    branch_transaction
    |> BranchTransaction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a branch_transaction.

  ## Examples

      iex> delete_branch_transaction(branch_transaction)
      {:ok, %BranchTransaction{}}

      iex> delete_branch_transaction(branch_transaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_branch_transaction(%BranchTransaction{} = branch_transaction) do
    Repo.delete(branch_transaction)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking branch_transaction changes.

  ## Examples

      iex> change_branch_transaction(branch_transaction)
      %Ecto.Changeset{source: %BranchTransaction{}}

  """
  def change_branch_transaction(%BranchTransaction{} = branch_transaction) do
    BranchTransaction.changeset(branch_transaction, %{})
  end
end
