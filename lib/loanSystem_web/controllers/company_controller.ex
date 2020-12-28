defmodule LoanSystemWeb.CompanyController do
  use LoanSystemWeb, :controller

  @moduledoc """
      Company Controller.
  """
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
    companies = Companies.list_tbl_companies()
       render(conn, "companies.html", companies: companies)
  end

  def staff(conn, _params) do
      staff = Companies.list_tbl_staff()
       render(conn, "staff.html", staff: staff)
  end

  def products(conn, _params) do
    product = Products.list_tbl_products()
    render(conn, "products.html", product: product)
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

def traverse_errors(errors) do
    for {key, {msg, _opts}} <- errors, do: "#{key} #{msg}"
  end

  # -------------------END OF ADD COMPANY FN -----------------





# -------------------ADD STAFF FN -----------------

  def add_staff(conn, params) do
    IO.inspect "-----------------------------------"
    IO.inspect params
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

    def traverse_errors(errors) do
      for {key, {msg, _opts}} <- errors, do: "#{key} #{msg}"
  end

  # -------------------END OF ADD STAFF FN -----------------

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

  def traverse_errors(errors) do
    for {key, {msg, _opts}} <- errors, do: "#{key} #{msg}"
  end

  # -------------------END OF ADD PRODUCT FN -----------------


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

      def traverse_errors(errors) do
        for {key, {msg, _opts}} <- errors, do: "#{key} #{msg}"
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

      def traverse_errors(errors) do
        for {key, {msg, _opts}} <- errors, do: "#{key} #{msg}"
      end

#disable company record

def disable_company(conn, params) do
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

def enable_company(conn, params) do
  companies = Companies.get_company!(params["id"])

  Ecto.Multi.new()
  |> Ecto.Multi.update(:companies, Company.changeset(companies, %{status: true}))
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
      conn |> json(%{message: "Company Enabled successfully", status: 1})
      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        conn |> json(%{message: reason, status: 0})
  end
end


def disable_product(conn, params) do
  product_data = Products.get_product!(params["id"])

  Ecto.Multi.new()
  |> Ecto.Multi.update(:product, Product.changeset(product_data, %{status: false}))
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
  |> Ecto.Multi.update(:product, Product.changeset(product_data, %{status: true}))
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

def disable_staff(conn, params) do
  staff_data = Companies.get_staff!(params["id"])

  Ecto.Multi.new()
  |> Ecto.Multi.update(:staff, Staff.changeset(staff_data, %{status: false}))
  |> Ecto.Multi.run(:user_log, fn (_, %{staff: staff}) ->
    activity = "Disabled staff with code \"#{staff.first_name}\""

      user_logs = %{
        user_id: conn.assigns.user.id,
        activity: activity
      }

      UserLogs.changeset(%UserLogs{}, user_logs)
      |> Repo.insert()
  end)
  |> Repo.transaction()
  |> case do
    {:ok, %{staff: _companies, user_log: _user_log}} ->
      conn |> json(%{message: "Staff Disabled successfully", status: 0})
      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        conn |> json(%{message: reason, status: 1})
  end
end

def enable_staff(conn, params) do
  staff_data = Companies.get_staff!(params["id"])

  Ecto.Multi.new()
  |> Ecto.Multi.update(:staff, Staff.changeset(staff_data, %{status: true}))
  |> Ecto.Multi.run(:user_log, fn (_, %{staff: staff}) ->
    activity = "Enabled staff with code \"#{staff.first_name}\""

      user_logs = %{
        user_id: conn.assigns.user.id,
        activity: activity
      }

      UserLogs.changeset(%UserLogs{}, user_logs)
      |> Repo.insert()
  end)
  |> Repo.transaction()
  |> case do
    {:ok, %{staff: _companies, user_log: _user_log}} ->
      conn |> json(%{message: "Staff Enabled successfully", status: 1})
      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        conn |> json(%{message: reason, status: 1})
  end
end

end
