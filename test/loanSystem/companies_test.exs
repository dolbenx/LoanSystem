defmodule LoanSystem.CompaniesTest do
  use LoanSystem.DataCase

  alias LoanSystem.Companies

  describe "tbl_companies" do
    alias LoanSystem.Companies.Company

    @valid_attrs %{address: "some address", city: "some city", company_id: "some company_id", company_name: "some company_name", country: "some country", date_of_incorporation: "some date_of_incorporation", email: "some email", phone: "some phone", tpin_no: "some tpin_no"}
    @update_attrs %{address: "some updated address", city: "some updated city", company_id: "some updated company_id", company_name: "some updated company_name", country: "some updated country", date_of_incorporation: "some updated date_of_incorporation", email: "some updated email", phone: "some updated phone", tpin_no: "some updated tpin_no"}
    @invalid_attrs %{address: nil, city: nil, company_id: nil, company_name: nil, country: nil, date_of_incorporation: nil, email: nil, phone: nil, tpin_no: nil}

    def company_fixture(attrs \\ %{}) do
      {:ok, company} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Companies.create_company()

      company
    end

    test "list_tbl_companies/0 returns all tbl_companies" do
      company = company_fixture()
      assert Companies.list_tbl_companies() == [company]
    end

    test "get_company!/1 returns the company with given id" do
      company = company_fixture()
      assert Companies.get_company!(company.id) == company
    end

    test "create_company/1 with valid data creates a company" do
      assert {:ok, %Company{} = company} = Companies.create_company(@valid_attrs)
      assert company.address == "some address"
      assert company.city == "some city"
      assert company.company_id == "some company_id"
      assert company.company_name == "some company_name"
      assert company.country == "some country"
      assert company.date_of_incorporation == "some date_of_incorporation"
      assert company.email == "some email"
      assert company.phone == "some phone"
      assert company.tpin_no == "some tpin_no"
    end

    test "create_company/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Companies.create_company(@invalid_attrs)
    end

    test "update_company/2 with valid data updates the company" do
      company = company_fixture()
      assert {:ok, %Company{} = company} = Companies.update_company(company, @update_attrs)
      assert company.address == "some updated address"
      assert company.city == "some updated city"
      assert company.company_id == "some updated company_id"
      assert company.company_name == "some updated company_name"
      assert company.country == "some updated country"
      assert company.date_of_incorporation == "some updated date_of_incorporation"
      assert company.email == "some updated email"
      assert company.phone == "some updated phone"
      assert company.tpin_no == "some updated tpin_no"
    end

    test "update_company/2 with invalid data returns error changeset" do
      company = company_fixture()
      assert {:error, %Ecto.Changeset{}} = Companies.update_company(company, @invalid_attrs)
      assert company == Companies.get_company!(company.id)
    end

    test "delete_company/1 deletes the company" do
      company = company_fixture()
      assert {:ok, %Company{}} = Companies.delete_company(company)
      assert_raise Ecto.NoResultsError, fn -> Companies.get_company!(company.id) end
    end

    test "change_company/1 returns a company changeset" do
      company = company_fixture()
      assert %Ecto.Changeset{} = Companies.change_company(company)
    end
  end

  describe "tbl_staff" do
    alias LoanSystem.Companies.Staff

    @valid_attrs %{address: "some address", city: "some city", company_id: "some company_id", company_name: "some company_name", country: "some country", email: "some email", first_name: "some first_name", id_no: "some id_no", id_type: "some id_type", last_name: "some last_name", other_name: "some other_name", phone: "some phone", tpin_no: "some tpin_no"}
    @update_attrs %{address: "some updated address", city: "some updated city", company_id: "some updated company_id", company_name: "some updated company_name", country: "some updated country", email: "some updated email", first_name: "some updated first_name", id_no: "some updated id_no", id_type: "some updated id_type", last_name: "some updated last_name", other_name: "some updated other_name", phone: "some updated phone", tpin_no: "some updated tpin_no"}
    @invalid_attrs %{address: nil, city: nil, company_id: nil, company_name: nil, country: nil, email: nil, first_name: nil, id_no: nil, id_type: nil, last_name: nil, other_name: nil, phone: nil, tpin_no: nil}

    def staff_fixture(attrs \\ %{}) do
      {:ok, staff} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Companies.create_staff()

      staff
    end

    test "list_tbl_staff/0 returns all tbl_staff" do
      staff = staff_fixture()
      assert Companies.list_tbl_staff() == [staff]
    end

    test "get_staff!/1 returns the staff with given id" do
      staff = staff_fixture()
      assert Companies.get_staff!(staff.id) == staff
    end

    test "create_staff/1 with valid data creates a staff" do
      assert {:ok, %Staff{} = staff} = Companies.create_staff(@valid_attrs)
      assert staff.address == "some address"
      assert staff.city == "some city"
      assert staff.company_id == "some company_id"
      assert staff.company_name == "some company_name"
      assert staff.country == "some country"
      assert staff.email == "some email"
      assert staff.first_name == "some first_name"
      assert staff.id_no == "some id_no"
      assert staff.id_type == "some id_type"
      assert staff.last_name == "some last_name"
      assert staff.other_name == "some other_name"
      assert staff.phone == "some phone"
      assert staff.tpin_no == "some tpin_no"
    end

    test "create_staff/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Companies.create_staff(@invalid_attrs)
    end

    test "update_staff/2 with valid data updates the staff" do
      staff = staff_fixture()
      assert {:ok, %Staff{} = staff} = Companies.update_staff(staff, @update_attrs)
      assert staff.address == "some updated address"
      assert staff.city == "some updated city"
      assert staff.company_id == "some updated company_id"
      assert staff.company_name == "some updated company_name"
      assert staff.country == "some updated country"
      assert staff.email == "some updated email"
      assert staff.first_name == "some updated first_name"
      assert staff.id_no == "some updated id_no"
      assert staff.id_type == "some updated id_type"
      assert staff.last_name == "some updated last_name"
      assert staff.other_name == "some updated other_name"
      assert staff.phone == "some updated phone"
      assert staff.tpin_no == "some updated tpin_no"
    end

    test "update_staff/2 with invalid data returns error changeset" do
      staff = staff_fixture()
      assert {:error, %Ecto.Changeset{}} = Companies.update_staff(staff, @invalid_attrs)
      assert staff == Companies.get_staff!(staff.id)
    end

    test "delete_staff/1 deletes the staff" do
      staff = staff_fixture()
      assert {:ok, %Staff{}} = Companies.delete_staff(staff)
      assert_raise Ecto.NoResultsError, fn -> Companies.get_staff!(staff.id) end
    end

    test "change_staff/1 returns a staff changeset" do
      staff = staff_fixture()
      assert %Ecto.Changeset{} = Companies.change_staff(staff)
    end
  end
end
