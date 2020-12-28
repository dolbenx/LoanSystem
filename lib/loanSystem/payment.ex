defmodule LoanSystem.Payment do
  @moduledoc """
  The Payment context.
  """

  import Ecto.Query, warn: false
  alias LoanSystem.Repo

  alias LoanSystem.Payment.PaymentDetails

  @doc """
  Returns the list of tbl_loan_transaction.

  ## Examples

      iex> list_tbl_loan_transaction()
      [%PaymentDetails{}, ...]

  """
  def list_tbl_loan_transaction do
    Repo.all(PaymentDetails)
  end

  @doc """
  Gets a single payment_details.

  Raises `Ecto.NoResultsError` if the Payment details does not exist.

  ## Examples

      iex> get_payment_details!(123)
      %PaymentDetails{}

      iex> get_payment_details!(456)
      ** (Ecto.NoResultsError)

  """
  def get_payment_details!(id), do: Repo.get!(PaymentDetails, id)

  @doc """
  Creates a payment_details.

  ## Examples

      iex> create_payment_details(%{field: value})
      {:ok, %PaymentDetails{}}

      iex> create_payment_details(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_payment_details(attrs \\ %{}) do
    %PaymentDetails{}
    |> PaymentDetails.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a payment_details.

  ## Examples

      iex> update_payment_details(payment_details, %{field: new_value})
      {:ok, %PaymentDetails{}}

      iex> update_payment_details(payment_details, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_payment_details(%PaymentDetails{} = payment_details, attrs) do
    payment_details
    |> PaymentDetails.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a payment_details.

  ## Examples

      iex> delete_payment_details(payment_details)
      {:ok, %PaymentDetails{}}

      iex> delete_payment_details(payment_details)
      {:error, %Ecto.Changeset{}}

  """
  def delete_payment_details(%PaymentDetails{} = payment_details) do
    Repo.delete(payment_details)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking payment_details changes.

  ## Examples

      iex> change_payment_details(payment_details)
      %Ecto.Changeset{source: %PaymentDetails{}}

  """
  def change_payment_details(%PaymentDetails{} = payment_details) do
    PaymentDetails.changeset(payment_details, %{})
  end
end
