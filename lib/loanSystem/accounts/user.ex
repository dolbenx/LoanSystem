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
    field :user_id, :string
    field :user_role, :string
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
      :phone,
      :sex,
      :status,
      :user_id,
      :user_role,
      :user_type
    ])
    |> validate_required([
      # :first_name,
      # :last_name,
      # :email,
      # :password,
      # :user_type,
      # :user_role,
      # :status,
      # :user_status,
      # :auto_password,
      # :sex,
      # :age,
      # :id_type,
      # :id_no,
      # :phone,
      # :creator_id,
      # :created_by,
      # :company_id,
      # :login_id,
      # :home_add,
      # :work_add,
      # :auth_level
    ])
    |> validate_length(:password,
      min: 4,
      max: 40,
      message: " should be atleast 4 to 40 characters"
    )
    |> validate_length(:first_name,
      min: 2,
      max: 100,
      message: "should be between 3 to 100 characters"
    )
    |> validate_length(:last_name,
      min: 2,
      max: 100,
      message: "should be between 3 to 100 characters"
    )
    |> validate_length(:email,
      min: 10,
      max: 150,
      message: "Email Length should be between 10 to 150 characters"
    )
    |> unique_constraint(:email, name: :unique_email, message: " Email address already exists")
    |> unique_constraint(:phone, name: :unique_phone, message: " Phone number already exists")
    |> validate_user_role()
    |> put_pass_hash
  end

  defp validate_user_role(
        %Ecto.Changeset{valid?: true, changes: %{user_type: type, user_role: role}} = changeset
      ) do
    case role == 1 && type == 2 do
      true ->
        add_error(changeset, :user, "under operations can't be admin")

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

# LoanSystem.Accounts.create_user(%{first_name: "admin", last_name: "admin", secondary_email: "admin@admin.com", email: "admin@probasegroup.com", password: "password06", auto_pwd: "Y", user_type: "1", status: "1", user_role: "ADMIN", id_type: "nrc", id_no: "365924101", secondary_phone: "09776655449", phone: "0955569017", inserted_at: NaiveDateTime.utc_now, updated_at: NaiveDateTime.utc_now})