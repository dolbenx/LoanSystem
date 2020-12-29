defmodule LoanSystemWeb.CompanyController do
  use LoanSystemWeb, :controller

  @moduledoc """
      Company Controller.
  """
  alias LoanSystem.Accounts
  alias LoanSystem.Accounts.User
  alias LoanSystem.Repo
  alias LoanSystem.Logs.UserLogs
  alias LoanSystem.Companies.Company
  alias LoanSystem.Companies.Staff
  alias LoanSystem.Products.Product
  alias LoanSystem.Products
  alias LoanSystem.Companies
  alias LoanSystem.SystemDirectories

  @headers ~w/ first_name last_name other_name id_no phone tpin_no email company_name city country address id_type account_no branch_id/a


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

  def staff(conn,  %{"company_id" => company_id}) do
    companies = Companies.comp_id(company_id)
    staff = Companies.list_stuff_with_company_id(company_id)
    render(conn, "staff.html", staff: staff, companies: companies)
  end

<<<<<<< HEAD
  def portal_admin(conn, %{"company_id" => company_id}) do
     companies = Companies.comp_id(company_id)
=======
  def staff_uploads(conn, _params) do
    companies = Companies.list_tbl_companies()
    staff = Companies.list_tbl_staff()
    render(conn, "staff_upload.html", companies: companies, staff: staff)
  end

  def portal_admin(conn, _params) do
>>>>>>> DAVIES
     system_users = Accounts.list_tbl_users()
     render(conn, "portal_admin.html", system_users: system_users, companies: companies)
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

  def handle_bulk_upload(conn, params) do
    user = conn.assigns.user

    {key, msg, _invalid} = handle_file_upload(user, params)

    if key == :info do
      conn
      |> put_flash(key, msg)
      |> redirect(to: Routes.company_path(conn, :staff_uploads))

    else
      conn
      |> put_flash(key, msg)
      |> redirect(to: Routes.company_path(conn, :staff_uploads))
    end
  end

  defp handle_file_upload(user, params) do

    with {:ok, filename, destin_path, _rows} <- is_valide_file(params) do
      user
      |> process_bulk_upload(filename, destin_path, params)
      |> case do
        {:ok, {invalid, valid}} ->
          {:info, "#{valid} Successful entrie(s) and #{invalid} invalid entrie(s)", invalid}

        {:error, reason} ->
          {:error, reason, 0}
      end
    else
      {:error, reason} ->
        {:error, reason, 0}
    end
  end


  def process_csv(file) do
    case File.exists?(file) do
      true ->
        data =
          File.stream!(file)
          |> CSV.decode!(separator: ?,, headers: true)
          |> Enum.map(& &1)

        {:ok, data}

      false ->
        {:error, "File does not exist"}
    end
  end


  def process_bulk_upload(user, filename, path, params) do
    # try do
      {:ok, items} = extract_xlsx(path)

      prepare_bulk_params(user, filename, items, params)
      |> Repo.transaction(timeout: 290_000)
      |> case do
        {:ok, multi_records} ->
          {invalid, valid} =
            multi_records
            |> Map.values()
            |> Enum.reduce({0, 0}, fn item, {invalid, valid} ->
              case item do
                %{staff_file_name: _src} -> {invalid, valid + 1}
                %{col_index: _index} -> {invalid + 1, valid}
                _ -> {invalid, valid}
              end
            end)

          {:ok, {invalid, valid}}

        {:error, _, changeset, _} ->
          # prepare_error_log(changeset, filename)
          reason = traverse_errors(changeset.errors) |> Enum.join("\r\n")
          {:error, reason}
      end
    # after
    #   filename = Path.rootname(filename) |> Path.basename()
    # end
  end

  defp prepare_bulk_params(user, filename, items, params) do

    items
    |> Stream.with_index(2)
    |> Stream.map(fn {item, index} ->
      changeset =
        %Staff{staff_file_name: filename, company_id: params["company_id"]}
        |> Staff.changeset(Map.put(item, :user_id, user.id))

      Ecto.Multi.insert(Ecto.Multi.new(), Integer.to_string(index), changeset)

    end)

    # |> filter_upload_errors(filename)
    |> Enum.reject(fn
      %{operations: [{_, {:run, _}}]} -> false
      %{operations: [{_, {_, changeset, _}}]} -> changeset.valid? == false
    end)
    |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
  end

  # ---------------------- file persistence --------------------------------------
  def is_valide_file(%{"staff_file_name" => params}) do
      if upload = params do
        case Path.extname(upload.filename) do
          ext when ext in ~w(.xlsx .XLSX .xls .XLS .csv .CSV) ->
            with {:ok, destin_path} <- persist(upload) do
              case ext not in ~w(.csv .CSV) do
                true ->
                  case Xlsxir.multi_extract(destin_path, 0, false, extract_to: :memory) do
                    {:ok, table_id} ->
                      row_count = Xlsxir.get_info(table_id, :rows)
                      Xlsxir.close(table_id)
                      {:ok, upload.filename, destin_path, row_count - 1}

                    {:error, reason} ->
                      {:error, reason}
                  end

                _ ->
                  {:ok, upload.filename, destin_path, "N(count)"}
              end
            else
              {:error, reason} ->
                {:error, reason}
            end

          regan ->
            IO.inspect "================================================================================="
            IO.inspect regan
            {:error, "Invalid File Format"}
        end
      else
        {:error, "No File Uploaded"}
      end
    end

  def csv(path, upload) do
    case process_csv(path) do
      {:ok, data} ->
        row_count = Enum.count(data)
        IO.inspect("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
        IO.inspect(row_count)

        case row_count do
          rows when rows in 1..100_000 ->
            {:ok, upload.filename, path, row_count}

          _ ->
            {:error, "File records should be between 1 to 100,000"}
        end

      {:error, reason} ->
        IO.inspect(reason)

        {:error, reason}
    end
  end



    def persist(%Plug.Upload{filename: filename, path: path}) do
      dir_path = SystemDirectories.directories()

      destin_path = (dir_path && dir_path.processed)  ||  "C:/Users/Dolben/Desktop/staffFile" |> default_dir()
      destin_path = Path.join(destin_path, filename)

        {_key, _resp} =
        with true <- File.exists?(destin_path) do
          {:error, "File with the same name aready exists"}
        else
          false ->
            File.cp(path, destin_path)
            {:ok, destin_path}
        end
    end



    def default_dir(path) do
      File.mkdir_p(path)
      path
    end


  def extract_xlsx(path) do
    case Xlsxir.multi_extract(path, 0, false, extract_to: :memory) do
      {:ok, id} ->
        items =
          Xlsxir.get_list(id)
          |> Enum.reject(&Enum.empty?/1)
          |> Enum.reject(&Enum.all?(&1, fn item -> is_nil(item)
        end))
          |> List.delete_at(0)
          |> Enum.map(
            &Enum.zip(
              Enum.map(@headers, fn h -> h end),
              Enum.map(&1, fn v -> strgfy_term(v) end)
            )
          )
          |> Enum.map(&Enum.into(&1, %{}))
          |> Enum.reject(&(Enum.join(Map.values(&1)) == ""))

        Xlsxir.close(id)
        {:ok, items}


      {:error, reason} ->
        {:error, reason}
    end
  end

    defp strgfy_term(term) when is_tuple(term), do: term
    defp strgfy_term(term) when not is_tuple(term), do: String.trim("#{term}")



    def traverse_errors(errors) do
      for {key, {msg, _opts}} <- errors, do: "#{key} #{msg}"
    end





end
