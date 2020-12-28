defmodule LoanSystem.Workers.FileReader do
  alias LoanSystem.Repo
  alias LoanSystem.SystemDirectories.Directory
  # @data_dir Path.join([__DIR__, "../../../", "priv/static/uploads"])


    # ---------------------- FILE READING: File Persistence --------------------
    def is_valide_file(%{"file" => params}) do
      if upload = params do
        case Path.extname(upload.filename) do
          ext when ext in ~w(.csv .CSV .xlsx .XLSX .xls .XLS) ->

            with {:ok, destin_path} <- persist(upload) do
              case ext do
                ".csv" -> csv(destin_path, upload)
                ".xlsx" -> excel(destin_path, upload)
                ".xls" -> excel(destin_path, upload)
              end
            else
              {:error, msg} ->
                {:error, msg}
            end
          _ ->
            {:error, "Invalid File Format"}
        end
      else
        {:error, "No File Uploaded"}
      end
    end

    def persist(%Plug.Upload{filename: filename, path: path}) do
  		dir_path = Repo.one(Directory)
  		destin_path = (dir_path && dir_path.processed) || "C:/Xampp/htdocs/work/elixir/probase/absa_sms/uploads" |> default_dir()
  		destin_path = Path.join(destin_path, filename)

      with true <- File.exists?(destin_path) do
        {:error, "File with same name already exist"}
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

    def csv(path, upload) do
      case process_csv(path) do
        {:ok, data} ->
          row_count = Enum.count(data)

          case row_count do
            rows when rows in 1..100_000 ->
              {:ok, upload.filename, path, row_count}
            _ ->
              {:error, "File records should be between 1 to 100,000"}
          end

        {:error, reason} ->
          {:error, reason}
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

    def excel(path, upload) do
      case Xlsxir.multi_extract(path, 0, false, extract_to: :memory) do
        {:ok, table_id} ->
          row_count = Xlsxir.get_info(table_id, :rows)
          Xlsxir.close(table_id)

          case row_count do
            rows when rows in 1..100_000 ->
              {:ok, upload.filename, path, row_count}

            _ ->
              {:error, "File records should be between 1 to 100,000"}
          end

        {:error, reason} ->

          {:error, reason}
      end
    end


    def extract_customized_broadcasts(path) do
      case Xlsxir.multi_extract(path, 0, false, extract_to: :memory) do
        {:ok, table_id} ->
          headers = List.first(Xlsxir.get_list(table_id))
          items =
            Xlsxir.get_list(table_id)
            |> Enum.uniq()
            |> Enum.reject(&Enum.empty?/1)
            |> Enum.reject(&Enum.all?(&1, fn item -> is_nil(item) end))
            |> List.delete_at(0)
            |> Enum.map(
              &Enum.zip(
                Enum.map(headers, fn h -> h end),
                Enum.map(&1, fn v -> strgfy_term(v) end)
              )
            )
            |> Enum.map(&Enum.into(&1, %{}))
            # |> Enum.uniq_by(&String.trim(&1.id_no))
            |> Enum.reject(&(Enum.join(Map.values(&1)) == ""))

          Xlsxir.close(table_id)
          {:ok, items}

        {:error, reason} ->
          {:error, reason}
      end
    end

    defp strgfy_term(term) when is_tuple(term), do: term
    defp strgfy_term(term) when not is_tuple(term), do: String.trim("#{term}")
    # -------------------------------------------------------------------------------


  # ------------------ xlsx extract ------------------------------------#
  def extract_mobile_msg(path) do
    case Xlsxir.multi_extract(path, 0, false, extract_to: :memory) do
      {:ok, id} ->
        recipients =
          Xlsxir.get_col(id, "A")
          |> Enum.reject(&(String.trim("#{&1}") == ""))

        messages =
          Xlsxir.get_col(id, "B")
          |> Enum.reject(&(String.trim("#{&1}") == ""))

        Xlsxir.close(id)
        {:ok, recipients, messages}

      {:error, reason} ->
        {:error, reason}
    end
  end

end
