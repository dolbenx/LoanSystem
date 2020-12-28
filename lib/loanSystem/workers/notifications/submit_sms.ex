defmodule FundsMgt.Workers.Sms do
  alias FundsMgt.ServiceProxy
  alias FundsMgt.Notifications
  alias Core.Constants
  alias Core.RunProcesses

  alias FundsMgt.Administration
  alias FundsMgt.System_settings

  # def perform() do
  #   Notifications.sms_ready()
  #   |> Task.async_stream(&send/1, max_concurrency: 5, timeout: 30_000)
  #   |> Stream.run
  # end


  def pending_sms() do
    case Notifications.sms_ready(Constants.ready()) do
      [] ->
        IO.puts("\n <<<<<<<  NO PENDING SMS' WERE FOUND >>>>>>> \n")
        []

      sms ->
        List.wrap(sms)
    end
  end

  def send() do
    Enum.each(pending_sms(), fn sms ->
      sms_params = prepare_sms_params(sms)
      headers = [{"Content-Type", "application/json"}]

      options = [
        ssl: [{:versions, [:"tlsv1.2"]}],
        timeout: 50_000,
        recv_timeout: 60_000,
        hackney: [:insecure]
      ]

      url = System_settings.get_settings_by(Constants.sms_url())

      RunProcesses.fire_process(url, Poison.encode!(sms_params), headers, options)
      |> RunProcesses.recieve_process()
      |> update_msgsms_log(sms)
    end)
  end

  defp prepare_sms_params(sms) do
    %{
      message: sms.msg,
      recipient: ["#{String.trim(sms.mobile_number)}"],
      senderid: System_settings.get_settings_by(Constants.sms_sender_id()),
      username: System_settings.get_settings_by(Constants.sms_auth_name()),
      password: System_settings.get_settings_by(Constants.sms_auth_password())
    }
  end

  def update_msgsms_log(status, msgsms_log) do
    count = (String.to_integer(msgsms_log.msg_count) + 1) |> Integer.to_string()
    case status do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case prepare_resp(Poison.decode!(body)) do
          "SUCCESS" ->
            IO.inspect(
              Notifications.update_msgsms_log(msgsms_log, %{
                status: "SUCCESS",
                date_sent: date_time(),
                msg_count: count
              })
            )

          _ ->
            IO.inspect("FAILED TO SEND TEXT")

            Notifications.update_msgsms_log(msgsms_log, %{
              status: "FAILED",
              date_sent: date_time(),
              msg_count: count
            })
        end

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "SERVICE_NOT_AVAILABLE"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  def prepare_resp(response) do
    %{"response" => status} = response
    case status do
      "successful"-> "SUCCESS"
      _any-> "FAILED"
    end
  end

  defp date_time(), do: to_string(Timex.today)
                    # do: DateTime.to_iso8601(Timex.local()) |> to_string |> String.slice(0..22)

end
