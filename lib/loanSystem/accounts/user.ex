defmodule LoanSystem.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_users" do
    field :age, :integer
    field :auto_password, :string
    field :email, :string
    field :first_name, :string
    field :home_add, :string
    field :id_no, :string
    field :id_type, :string
    field :last_name, :string
    field :password, :string
    field :phone, :integer
    field :sex, :string
    field :status, :integer
    field :user_id, :integer
    field :user_role, :string
    field :company_id, :string
    field :user_type, :integer

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [
      :age,
      :auto_password,
      :email,
      :first_name,
      :home_add,
      :id_no,
      :id_type,
      :last_name,
      :password,
      :phone,
      :sex,
      :status,
      :user_id,
      :user_role,
      :user_type,
      :company_id
    ])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 8, max: 40, message: " should be atleast 8 to 40 characters")
    |> validate_format(:password, ~r/[0-9]+/, message: "Password must contain a number") # has a number
    |> validate_format(:password, ~r/[A-Z]+/, message: "Password must contain an upper-case letter") # has an upper case letter
    |> validate_format(:password, ~r/[a-z]+/, message: "Password must contain a lower-case letter") # has a lower case letter
    |> validate_format(:password, ~r/[#\!\?&@\$%^&*\(\)]+/, message: "Password must contain a special character") # Has a symbol
    |> validate_length(:first_name, min: 2, max: 100, message: "should be between 3 to 100 characters")
    |> validate_length(:last_name, min: 2, max: 100, message: "should be between 3 to 100 characters")
    |> validate_length(:email, min: 10, max: 150, message: "Email Length should be between 10 to 150 characters")
    |> unique_constraint(:email, name: :unique_email, message: " Email address already exists")
    |> unique_constraint(:phone, name: :unique_phone, message: " Phone number already exists")
    |> unique_constraint(:id_no, name: :unique_identity_number, message: " ID number already exists")
    |> validate_user_role()
    |> put_pass_hash
  end

  defp validate_user_role(
         %Ecto.Changeset{valid?: true, changes: %{user_type: type, user_role: role}} = changeset
       ) do
    case role == ADMIN && type == 1 do
      true ->
        add_error(changeset, :user, "under operations can't be Admin")

      _ ->
        changeset
    end

    case role == AUTHORIZER && type == 2 do
      true ->
        add_error(changeset, :user, "under operations can't be Admin Authorizer")

      _ ->
        changeset
    end

    case role == CLIENT && type == 3 do
      true ->
        add_error(changeset, :user, "under operations can't be Client HR")

      _ ->
        changeset
    end

    case role == CLIENT_AUTHORIZER && type == 4 do
      true ->
        add_error(changeset, :user, "under operations can't be Client Authorizer")

      _ ->
        changeset
    end
  end

  defp validate_user_role(changeset), do: changeset


  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    Ecto.Changeset.put_change(changeset, :password, encrypt_password(password))
  end

  defp put_pass_hash(changeset), do: changeset

  @spec encrypt_password(
          binary
          | maybe_improper_list(
              binary | maybe_improper_list(any, binary | []) | byte,
              binary | []
            )
        ) :: binary
  def encrypt_password(password), do: Base.encode16(:crypto.hash(:sha512, password))
end

# LoanSystem.Accounts.create_user(%{first_name: "admin", last_name: "admin", email: "admin@probasegroup.com", password: "Password@06", auto_pwd: "Y", user_type: "1", status: "1", user_role: "ADMIN", id_type: "NRC", id_no: "365924101", secondary_phone: "09776655449", phone: "0955569017", inserted_at: NaiveDateTime.utc_now, updated_at: NaiveDateTime.utc_now})
# LoanSystem.Accounts.create_user(%{first_name: "Adriel", last_name: "Phiri", email: "authorizer@probasegroup.com", password: "Password@06", auto_pwd: "Y", user_type: "2", status: "1", user_role: "AUTHORIZER", id_type: "NRC", id_no: "365924101", secondary_phone: "09776655449", phone: "0955569017", inserted_at: NaiveDateTime.utc_now, updated_at: NaiveDateTime.utc_now})



# LoanSystem.Accounts.create_user(%{first_name: "Client", last_name: "Probase", email: "client@probasegroup.com", password: "Password@06", auto_pwd: "Y", user_type: "3", status: "1", user_role: "CLIENT", id_type: "nrc", id_no: "365924101", secondary_phone: "09776655449", phone: "0955569017", inserted_at: NaiveDateTime.utc_now, updated_at: NaiveDateTime.utc_now})
# LoanSystem.Accounts.create_user(%{first_name: "Client", last_name: "Auth", email: "clientauth@probasegroup.com", password: "Password@06", auto_pwd: "Y", user_type: "4", status: "1", user_role: "CLIENT_AUTHORIZER", id_type: "nrc", id_no: "365924101", secondary_phone: "09776655449", phone: "0955569017", inserted_at: NaiveDateTime.utc_now, updated_at: NaiveDateTime.utc_now})
