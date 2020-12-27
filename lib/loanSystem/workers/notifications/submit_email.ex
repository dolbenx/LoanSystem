defmodule FundsMgt.Workers.Email do
    import Bamboo.Email
    alias FundsMgt.Emails.Mailer
    alias FundsMgt.ServiceProxy
    alias FundsMgt.Notifications
    alias Core.Constants
    alias Core.RunProcesses

    alias FundsMgt.Admin
# defmodule SmartPAY.Workers.Email do
#     import Bamboo.Email
#     alias SmartPAY.Emails.Mailer
#     alias SmartPAY.ServiceProxy
#     alias SmartPAY.Notifications
#     alias Core.Constants
#     alias Core.RunProcesses

#     alias SmartPAY.Admin

#     def pending_email() do
#       case Notifications.email_ready(Constants.ready()) do
#         [] ->
#           IO.puts("\n <<<<<<<  NO PENDING Emails' WERE FOUND >>>>>>> \n")
#           []

#         email ->
#           List.wrap(email)
#       end
#     end

#     def send() do
#         Enum.each(pending_email(), fn email ->
#             new_email()
#             |> from(email.sender_email)
#             |> to(email.recipient_email)
#             |> subject(email.subject)
#             |> text_body(email.mail_body)
#             |> Mailer.deliver_later()
#         end)
#     end

#     # def send() do
#     #   Enum.each(pending_sms(), fn sms ->
#     #     sms_params = prepare_sms_params(sms)
#     #     headers = [{"Content-Type", "application/json"}]

#     #     options = [
#     #       ssl: [{:versions, [:"tlsv1.2"]}],
#     #       timeout: 50_000,
#     #       recv_timeout: 60_000,
#     #       hackney: [:insecure]
#     #     ]

#     #     url = Admin.get_settings_by(Constants.sms_url())

#     #     RunProcesses.fire_process(url, Poison.encode!(sms_params), headers, options)
#     #     |> RunProcesses.recieve_process()
#     #     |> update_sms(sms)
#     #   end)
#     # end

#     # defp prepare_sms_params(sms) do
#     #   %{
#     #     message: sms.msg,
#     #     recipient: ["#{String.trim(sms.mobile)}"],
#     #     senderid: Admin.get_settings_by(Constants.sms_sender_id()),
#     #     username: Admin.get_settings_by(Constants.sms_auth_name()),
#     #     password: Admin.get_settings_by(Constants.sms_auth_password())
#     #   }
#     # end

#     # def update_sms(status, sms) do
#     #   count = (String.to_integer(sms.msg_count) + 1) |> Integer.to_string()
#     #   case status do
#     #     {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
#     #       case prepare_resp(Poison.decode!(body)) do
#     #         "SUCCESS" ->
#     #           IO.inspect(
#     #             Notifications.update_sms(sms, %{
#     #               status: "SUCCESS",
#     #               date_sent: date_time(),
#     #               msg_count: count
#     #             })
#     #           )

#     #         _ ->
#     #           IO.inspect("FAILED TO SEND TEXT")

#     #           Notifications.update_sms(sms, %{
#     #             status: "FAILED",
#     #             date_sent: date_time(),
#     #             msg_count: count
#     #           })
#     #       end

#     #     {:ok, %HTTPoison.Response{status_code: 404}} ->
#     #       {:error, "SERVICE_NOT_AVAILABLE"}

#     #     {:error, %HTTPoison.Error{reason: reason}} ->
#     #       {:error, reason}
#     #   end
#     # end

#     # def prepare_resp(response) do
#     #   %{"response" => [%{"messagestatus" => status}]} = response
#     #   status
#     # end

#     defp date_time(), do: DateTime.to_iso8601(Timex.local()) |> to_string |> String.slice(0..22)
#   end


    def pending_email() do
      # case Notifications.email_ready(Constants.ready()) do
        # [] ->
        #   IO.puts("\n <<<<<<<  NO PENDING Emails' WERE FOUND >>>>>>> \n")
        #   []

        # email ->
        #   List.wrap(email)

    end

    def send() do
        Enum.each(pending_email(), fn email ->
            new_email()
            |> from(email.sender_email)
            |> to(email.recipient_email)
            |> subject(email.subject)
            |> text_body(email.mail_body)
            |> Mailer.deliver_later()
        end)
    end

    # def send() do
    #   Enum.each(pending_email(), fn email ->
    #     email_params = prepare_email_params(sms)
    #     headers = [{"Content-Type", "application/json"}]

    #     options = [
    #       ssl: [{:versions, [:"tlsv1.2"]}],
    #       timeout: 50_000,
    #       recv_timeout: 60_000,
    #       hackney: [:insecure]
    #     ]

    #     url = Admin.get_settings_by(Constants.email_url())

    #     RunProcesses.fire_process(url, Poison.encode!(email_params), headers, options)
    #     |> RunProcesses.recieve_process()
    #     |> update_email(email)
    #   end)
    # end

    # defp prepare_email_params(email) do
    #   %{
    #     message: sms.msg,
    #     sender_email: ["#{String.trim(sender_email)}"],
    #     recipient_email: Admin.get_settings_by(Constants.recipient_email()),
    #     subject: Admin.get_settings_by(Constants.subject()),
    #     mail_body: Admin.get_settings_by(Constants.mail_body())
    #   }
    # end


    # def update_email(status, email) do
    #   count = (String.to_integer(email.msg_count) + 1) |> Integer.to_string()
    #   case status do
    #     {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
    #       case prepare_resp(Poison.decode!(body)) do
    #         "SUCCESS" ->
    #           IO.inspect(
    #             Notifications.update_email(email, %{
    #               status: "SUCCESS",
    #               date_sent: date_time(),
    #               msg_count: count
    #             })
    #           )

    #         _ ->
    #           IO.inspect("FAILED TO SEND TEXT")

    #           Notifications.update_email(email, %{
    #             status: "FAILED",
    #             date_sent: date_time(),
    #             email_count: count
    #           })
    #       end

    #     {:ok, %HTTPoison.Response{status_code: 404}} ->
    #       {:error, "SERVICE_NOT_AVAILABLE"}

    #     {:error, %HTTPoison.Error{reason: reason}} ->
    #       {:error, reason}
    #   end
    # end

    # def prepare_resp(response) do
    #   %{"response" => [%{"messagestatus" => status}]} = response
    #   status
    # end

    # defp date_time(), do: DateTime.to_iso8601(Timex.local()) |> to_string |> String.slice(0..22)
  end
