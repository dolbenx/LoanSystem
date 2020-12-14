defmodule LoanSystem.AccountsTest do
  use LoanSystem.DataCase

  alias LoanSystem.Accounts

  describe "tbl_users" do
    alias LoanSystem.Accounts.User

    @valid_attrs %{age: 42, auto_password: "some auto_password", email: "some email", first_name: "some first_name", home_add: "some home_add", id_no: 42, id_type: "some id_type", last_name: "some last_name", password: "some password", phone: 42, sex: "some sex", status: 42, user_role: "some user_role", user_type: 42}
    @update_attrs %{age: 43, auto_password: "some updated auto_password", email: "some updated email", first_name: "some updated first_name", home_add: "some updated home_add", id_no: 43, id_type: "some updated id_type", last_name: "some updated last_name", password: "some updated password", phone: 43, sex: "some updated sex", status: 43, user_role: "some updated user_role", user_type: 43}
    @invalid_attrs %{age: nil, auto_password: nil, email: nil, first_name: nil, home_add: nil, id_no: nil, id_type: nil, last_name: nil, password: nil, phone: nil, sex: nil, status: nil, user_role: nil, user_type: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_tbl_users/0 returns all tbl_users" do
      user = user_fixture()
      assert Accounts.list_tbl_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.age == 42
      assert user.auto_password == "some auto_password"
      assert user.email == "some email"
      assert user.first_name == "some first_name"
      assert user.home_add == "some home_add"
      assert user.id_no == 42
      assert user.id_type == "some id_type"
      assert user.last_name == "some last_name"
      assert user.password == "some password"
      assert user.phone == 42
      assert user.sex == "some sex"
      assert user.status == 42
      assert user.user_role == "some user_role"
      assert user.user_type == 42
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.age == 43
      assert user.auto_password == "some updated auto_password"
      assert user.email == "some updated email"
      assert user.first_name == "some updated first_name"
      assert user.home_add == "some updated home_add"
      assert user.id_no == 43
      assert user.id_type == "some updated id_type"
      assert user.last_name == "some updated last_name"
      assert user.password == "some updated password"
      assert user.phone == 43
      assert user.sex == "some updated sex"
      assert user.status == 43
      assert user.user_role == "some updated user_role"
      assert user.user_type == 43
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "tbl_users" do
    alias LoanSystem.Accounts.User

    @valid_attrs %{age: 42, auto_password: "some auto_password", email: "some email", first_name: "some first_name", home_add: "some home_add", id_no: 42, id_type: "some id_type", last_name: "some last_name", password: "some password", phone: 42, sex: "some sex", status: 42, user_id: "some user_id", user_role: "some user_role", user_type: 42}
    @update_attrs %{age: 43, auto_password: "some updated auto_password", email: "some updated email", first_name: "some updated first_name", home_add: "some updated home_add", id_no: 43, id_type: "some updated id_type", last_name: "some updated last_name", password: "some updated password", phone: 43, sex: "some updated sex", status: 43, user_id: "some updated user_id", user_role: "some updated user_role", user_type: 43}
    @invalid_attrs %{age: nil, auto_password: nil, email: nil, first_name: nil, home_add: nil, id_no: nil, id_type: nil, last_name: nil, password: nil, phone: nil, sex: nil, status: nil, user_id: nil, user_role: nil, user_type: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_tbl_users/0 returns all tbl_users" do
      user = user_fixture()
      assert Accounts.list_tbl_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.age == 42
      assert user.auto_password == "some auto_password"
      assert user.email == "some email"
      assert user.first_name == "some first_name"
      assert user.home_add == "some home_add"
      assert user.id_no == 42
      assert user.id_type == "some id_type"
      assert user.last_name == "some last_name"
      assert user.password == "some password"
      assert user.phone == 42
      assert user.sex == "some sex"
      assert user.status == 42
      assert user.user_id == "some user_id"
      assert user.user_role == "some user_role"
      assert user.user_type == 42
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.age == 43
      assert user.auto_password == "some updated auto_password"
      assert user.email == "some updated email"
      assert user.first_name == "some updated first_name"
      assert user.home_add == "some updated home_add"
      assert user.id_no == 43
      assert user.id_type == "some updated id_type"
      assert user.last_name == "some updated last_name"
      assert user.password == "some updated password"
      assert user.phone == 43
      assert user.sex == "some updated sex"
      assert user.status == 43
      assert user.user_id == "some updated user_id"
      assert user.user_role == "some updated user_role"
      assert user.user_type == 43
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
