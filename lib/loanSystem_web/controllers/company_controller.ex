defmodule LoanSystemWeb.CompanyController do
  use LoanSystemWeb, :controller

  @moduledoc """
      Company Controller.
  """
  alias LoanSystem.Accounts
  alias LoanSystem.Repo
  alias LoanSystem.Logs.UserLogs
  alias LoanSystem.Companies.Company
  alias LoanSystem.Companies.Staff
  alias LoanSystem.Products.Product
  alias LoanSystem.Products
  alias LoanSystem.Companies

  def reports(conn, _params) do
    render(conn, "reports.html")
  end

  def logs(conn, _params) do
    render(conn, "logs.html")

  end
  def companies(conn, _params) do
    products = Products.list_tbl_products()
    companies = Companies.list_tbl_companies()
    render(conn, "companies.html", companies: companies, products: products)
  end

  def staff(conn,  %{"company_id" => company_id}) do
    companies = Companies.comp_id(company_id)
    staff = Companies.list_stuff_with_company_id(company_id)
    render(conn, "staff.html", staff: staff, companies: companies)
  end

  def staff_uploads(conn, _params) do
    companies = Companies.list_tbl_companies()
    staff = Companies.list_tbl_staff()
    render(conn, "staff_upload.html", companies: companies, staff: staff)
  end

  def portal_admin(conn, %{"company_id" => company_id}) do
     companies = Companies.comp_id(company_id)
     client_users = Accounts.get_client_users(company_id)
     render(conn, "portal_admin.html", client_users: client_users, companies: companies)
  end
  def products(conn, _params) do

    product = Products.list_tbl_products()
    render(conn, "products.html", product: product)
  end

  def generate_company() do
  random = Enum.random(111111..999999) |> to_string
  year = to_string(Timex.now()|> Timex.format!("%Y", :strftime)|>String.slice(-2..-1))
  month = to_string(Timex.format!(Timex.today(), "%m", :strftime))
  year<>""<>month<>""<>random
end

def generate_company_id(conn, _param) do
  account = generate_company()
  json(conn, %{"account" => account})
end

# -------------------ADD COMPANY FN -----------------

  def add_company(conn, params) do
    IO.inspect "-----------------------------------"
    IO.inspect params
  Ecto.Multi.new()
  |> Ecto.Multi.insert(:companies, Company.changeset(%Company{}, params))
  |> Ecto.Multi.run(:user_log, fn(_, %{companies: _companies}) ->
  activity = "Company has been Added"


  user_log = %{
  user_id: conn.assigns.user.id,
  activity: activity
  }

  UserLogs.changeset(%UserLogs{}, user_log)
  |> Repo.insert()
  end)
  |> Repo.transaction()
  |> case do
  {:ok, %{companies: _companies, user_log: _user_log}} ->
  conn
  |> put_flash(:info, "Company has been Added Successfully.")
  |> redirect(to: Routes.company_path(conn, :companies))

  {:error, _failed_operation, failed_value, _changes_so_far} ->
  reason = traverse_errors(failed_value.errors) |> List.first()
  conn
  |> put_flash(:error, reason)
  |> redirect(to: Routes.company_path(conn, :companies))
  end
  # rescue
  # _ ->
  # conn
  # |> put_flash(:error, "An error occurred, reason unknown. try again")
  # |> redirect(to: Routes.customer_path(conn, :index))
  end

  # -------------------END OF ADD COMPANY FN -----------------





# -------------------ADD STAFF FN -----------------

  def add_staff(conn, params) do
    IO.inspect "-----------------------------------"
    IO.inspect params
    %{"company_id" => company_id} = params
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:staff, Staff.changeset(%Staff{}, params))
    |> Ecto.Multi.run(:user_log, fn(_, %{staff: _staff}) ->
    activity = "Staff has been Added"
    # activity = "Staff has been Added Successfully"

  user_log = %{
  user_id: conn.assigns.user.id,
  activity: activity
  }

  UserLogs.changeset(%UserLogs{}, user_log)
  |> Repo.insert()
  end)
  |> Repo.transaction()
  |> case do
  {:ok, %{staff: _staff, user_log: _user_log}} ->
  conn
  |> put_flash(:info, "Staff has been Added Successfully.")
  |> redirect(to: Routes.company_path(conn, :staff, company_id: company_id))

  {:error, _failed_operation, failed_value, _changes_so_far} ->
  reason = traverse_errors(failed_value.errors) |> List.first()
  conn
  |> put_flash(:error, reason)
  |> redirect(to: Routes.company_path(conn, :staff, company_id: company_id))
  end
  # rescue
  # _ ->
  # conn
  # |> put_flash(:error, "An error occurred, reason unknown. try again")
  # |> redirect(to: Routes.customer_path(conn, :index))
  end
  # -------------------END OF ADD STAFF FN -----------------

     # -------------------UPDATE COMPANY FN -----------------

     def update_company(conn, params) do
      IO.inspect params
      companies = Companies.get_company!(params["id"])
      Ecto.Multi.new()
      |> Ecto.Multi.update(:companies, Company.changeset(companies, params))
      |> Ecto.Multi.run(:user_log, fn (_, %{companies: _companies}) ->
          activity = "Updated Company with code \"#{companies.company_name}\""

          user_logs = %{
            user_id: conn.assigns.user.id,
            activity: activity
          }

          UserLogs.changeset(%UserLogs{}, user_logs)
          |> Repo.insert()
      end)
      |> Repo.transaction()
      |> case do
        {:ok, %{companies: _companies, user_log: _user_log}} ->
          conn
          |> put_flash(:info, "Company details updated successfully")
          |> redirect(to: Routes.company_path(conn, :companies))

          {:error, _failed_operation, failed_value, _changes_so_far} ->
            reason = traverse_errors(failed_value.errors) |> List.first()
            conn
            |> put_flash(:error, reason)
            |> redirect(to: Routes.company_path(conn, :companies))
      end
    end


    def update_product(conn, params) do
      product_data = Products.get_product!(params["id"])
      Ecto.Multi.new()
      |> Ecto.Multi.update(:product, Product.changeset(product_data, params))
      |> Ecto.Multi.run(:user_log, fn(_, %{product: product}) ->
            activity = "Updated product with code \"#{product.name}\""

            # activity = "Staff has been Added Successfully"

            user_log = %{
                user_id: conn.assigns.user.id,
                activity: activity
            }

            UserLogs.changeset(%UserLogs{}, user_log)
            |> Repo.insert()
            end)
            |> Repo.transaction()
            |> case do
            {:ok, %{product: _staff, user_log: _user_log}} ->
            conn
            |> put_flash(:info, "Product has been updates Successfully.")
            |> redirect(to: Routes.company_path(conn, :products))

            {:error, _failed_operation, failed_value, _changes_so_far} ->
            reason = traverse_errors(failed_value.errors) |> List.first()
            conn
            |> put_flash(:error, reason)
            |> redirect(to: Routes.company_path(conn, :products))
            end
            # rescue
            # _ ->
            # conn
            # |> put_flash(:error, "An error occurred, reason unknown. try again")
            # |> redirect(to: Routes.customer_path(conn, :index))
            end

            def update_staff(conn, params) do
              staff_data = Companies.get_staff!(params["id"])
              Ecto.Multi.new()
              |> Ecto.Multi.update(:staff, Staff.changeset(staff_data, params))
              |> Ecto.Multi.run(:user_log, fn(_, %{staff: staff}) ->
                    activity = "Updated Staff with code \"#{staff.first_name}\""

                    # activity = "Staff has been Added Successfully"

                    user_log = %{
                        user_id: conn.assigns.user.id,
                        activity: activity
                    }

                    UserLogs.changeset(%UserLogs{}, user_log)
                    |> Repo.insert()
                    end)
                    |> Repo.transaction()
                    |> case do
                    {:ok, %{staff: _staff, user_log: _user_log}} ->
                    conn
                    |> put_flash(:info, "Staff has been updates Successfully.")
                    |> redirect(to: Routes.company_path(conn, :staff))

                    {:error, _failed_operation, failed_value, _changes_so_far} ->
                    reason = traverse_errors(failed_value.errors) |> List.first()
                    conn
                    |> put_flash(:error, reason)
                    |> redirect(to: Routes.company_path(conn, :staff))
                    end
                    # rescue
                    # _ ->
                    # conn
                    # |> put_flash(:error, "An error occurred, reason unknown. try again")
                    # |> redirect(to: Routes.customer_path(conn, :index))
                    end



  #disable company record

  def disable(conn, params) do
    companies = Companies.get_company!(params["id"])
    Ecto.Multi.new()
    |> Ecto.Multi.update(:companies, Company.changeset(companies, %{status: false}))
    |> Ecto.Multi.run(:user_log, fn (_, %{companies: _companies}) ->
        activity = "Updated Company with code \"#{companies.company_name}\""

        user_logs = %{
          user_id: conn.assigns.user.id,
          activity: activity
        }

        UserLogs.changeset(%UserLogs{}, user_logs)
        |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{companies: _companies, user_log: _user_log}} ->
        conn |> json(%{message: "Company Disabled successfully", status: 0})
        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()
          conn |> json(%{message: reason, status: 1})
    end


  end

# -------------------ADD PRODUCT FN -----------------

  def add_product(conn, params) do
    IO.inspect "-----------------------------------"
    IO.inspect params
  Ecto.Multi.new()
    |> Ecto.Multi.insert(:product, Product.changeset(%Product{}, params))
    |> Ecto.Multi.run(:user_log, fn(_, %{product: _product}) ->
  activity = "Product has been Added"
  # activity = "Product has been Added Successfully"

  user_log = %{
  user_id: conn.assigns.user.id,
  activity: activity
  }

  UserLogs.changeset(%UserLogs{}, user_log)
  |> Repo.insert()
  end)
  |> Repo.transaction()
  |> case do
  {:ok, %{product: _product, user_log: _user_log}} ->
  conn
  |> put_flash(:info, "Product has been Added Successfully.")
  |> redirect(to: Routes.company_path(conn, :products))

  {:error, _failed_operation, failed_value, _changes_so_far} ->
  reason = traverse_errors(failed_value.errors) |> List.first()
  conn
  |> put_flash(:error, reason)
  |> redirect(to: Routes.company_path(conn, :products))
  end
  # rescue
  # _ ->
  # conn
  # |> put_flash(:error, "An error occurred, reason unknown. try again")
  # |> redirect(to: Routes.customer_path(conn, :index))
  end

  # -------------------END OF ADD PRODUCT FN -----------------


    def traverse_errors(errors) do
      for {key, {msg, _opts}} <- errors, do: "#{key} #{msg}"
    end

    def disable_product(conn, params) do
      product_data = Products.get_product!(params["id"])

      Ecto.Multi.new()
      |> Ecto.Multi.update(:product, Product.changeset(product_data, %{status: "INACTIVE" }))
      |> Ecto.Multi.run(:user_log, fn (_, %{product: product}) ->
        activity = "Disabled product with code \"#{product.name}\""

          user_logs = %{
            user_id: conn.assigns.user.id,
            activity: activity
          }

          UserLogs.changeset(%UserLogs{}, user_logs)
          |> Repo.insert()
      end)
      |> Repo.transaction()
      |> case do
        {:ok, %{product: _companies, user_log: _user_log}} ->
          conn |> json(%{message: "Product Disabled successfully", status: 0})
          {:error, _failed_operation, failed_value, _changes_so_far} ->
            reason = traverse_errors(failed_value.errors) |> List.first()
            conn |> json(%{message: reason, status: 1})
      end
    end


    def enable_product(conn, params) do
      product_data = Products.get_product!(params["id"])

      Ecto.Multi.new()
      |> Ecto.Multi.update(:product, Product.changeset(product_data, %{status: "ACTIVE" }))
      |> Ecto.Multi.run(:user_log, fn (_, %{product: product}) ->
        activity = "Enable product with code \"#{product.name}\""

          user_logs = %{
            user_id: conn.assigns.user.id,
            activity: activity
          }

          UserLogs.changeset(%UserLogs{}, user_logs)
          |> Repo.insert()
      end)
      |> Repo.transaction()
      |> case do
        {:ok, %{product: _companies, user_log: _user_log}} ->
          conn |> json(%{message: "Product enable successfully", status: 1})
          {:error, _failed_operation, failed_value, _changes_so_far} ->
            reason = traverse_errors(failed_value.errors) |> List.first()
            conn |> json(%{message: reason, status: 1})
      end
    end





end
