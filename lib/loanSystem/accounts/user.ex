defmodule LoanSystem.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_users" do
    field :acc_inactive_reason, :string
    field :address, :string
    field :age, :integer
    field :auto_password, :string
    field :created_by, :string
    field :creator_id, :integer
    field :email, :string
    field :first_name, :string
    field :id_no, :string
    field :id_type, :string
    field :last_modified_by, :string
    field :last_name, :string
    field :loan_officer, :integer
    field :password, :string
    field :phone, :string
    field :sex, :string
    field :status, :integer
    field :title, :string
    field :user_role, :string
    field :user_type, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:title, :first_name, :last_name, :email, :password, :user_type, :user_role, :status, :auto_password, :sex, :age, :id_type, :id_no, :phone, :address, :creator_id, :acc_inactive_reason, :last_modified_by, :created_by, :loan_officer])
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
    |> unique_constraint(:identity_number, name: :unique_identity_number, message: " ID number already exists")
    |> validate_user_role()
    |> put_pass_hash
  end

  defp validate_user_role(
         %Ecto.Changeset{valid?: true, changes: %{user_type: type, user_role: role}} = changeset
       ) do
    case role == ADMIN && type == 1 do
      true ->
        add_error(changeset, :user, "under operations can't be admin")

      _ ->
        changeset
    end

    case role == PRODUCT_MANAGER_AUTHORIZATION && type == 2 do
      true ->
        add_error(changeset, :user, "under operations can't be PRODUCT_MANAGER_AUTHORIZATION")

      _ ->
        changeset
    end

    case role == CLIENT_ADMIN && type == 3 do
      true ->
        add_error(changeset, :user, "under operations can't be PRODUCT_MANAGER_DEFINITION")

      _ ->
        changeset
    end

    case role == CLIENT_PRODUCT_MANAGER_AUTHORIZATION && type == 4 do
      true ->
        add_error(changeset, :user, "under operations can't be BACK_OFFICE_MANAGER")

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


# LoanSystem.Accounts.create_user(%{first_name: "Davies", last_name: "Phiri", email: "admin@probasegroup.com", password: "Password@06", auto_password: "Y", user_type: 1, status: 1, user_role: "ADMIN", sex: "m", age: "24", id_type: "nrc", id_no: "304831101", autopasword: "Y", phone: "0978242442", inserted_at: NaiveDateTime.utc_now, updated_at: NaiveDateTime.utc_now})
# LoanSystem.Accounts.create_user(%{first_name: "Chiza", last_name: "Mhlanga", email: "adminauthorizer@probasegroup.com", password: "Password@06", auto_password: "Y", user_type: 2, status: 1, user_role: "PRODUCT_MANAGER_AUTHORIZATION", sex: "m", age: "24", id_type: "nrc", id_no: "304531101", autopasword: "Y", phone: "0978242455", inserted_at: NaiveDateTime.utc_now, updated_at: NaiveDateTime.utc_now})
# LoanSystem.Accounts.create_user(%{first_name: "Chiza", last_name: "Mhlanga", email: "client@probasegroup.com", password: "Password@07", auto_password: "Y", user_type: 3, status: 1, user_role: "CLIENT_ADMIN", sex: "m", age: "24", id_type: "nrc", id_no: "302231101", autopasword: "Y", phone: "0968242455", inserted_at: NaiveDateTime.utc_now, updated_at: NaiveDateTime.utc_now})
# LoanSystem.Accounts.create_user(%{first_name: "Client", last_name: "Authorizer", email: "clientauthorizer@probasegroup.com", password: "Password@06", auto_password: "Y", user_type: 4, status: 1, user_role: "CLIENT_PRODUCT_MANAGER_AUTHORIZATION", sex: "m", age: "24", id_type: "nrc", id_no: "303431101", autopasword: "Y", phone: "0978242225", inserted_at: NaiveDateTime.utc_now, updated_at: NaiveDateTime.utc_now})
# LoanSystem.Accounts.create_user(%{first_name: "Client", last_name: "Authorizer", email: "clientauthorizer@probasegroup.com", password: "Password@06", auto_password: "Y", user_type: 4, status: 1, user_role: "CLIENT_PRODUCT_MANAGER_AUTHORIZATION", sex: "m", age: "24", id_type: "nrc", id_no: "303431101", autopasword: "Y", phone: "0978242225", inserted_at: NaiveDateTime.utc_now, updated_at: NaiveDateTime.utc_now})
# LoanSystem.Accounts.create_user(%{first_name: "teddy", last_name: "chiingu", email: "teddychiingujr@gmail.com", password: "Ted@1234", auto_password: "Y", user_type: 1, status: 1, user_role: "ADMIN", sex: "m", age: "24", id_type: "nrc", id_no: "304831101", autopasword: "Y", phone: "0978242442", inserted_at: NaiveDateTime.utc_now, updated_at: NaiveDateTime.utc_now})
