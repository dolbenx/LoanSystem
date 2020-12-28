defmodule FundsMgt.Workers.SingleWorker do
  alias FundsMgt.Email


  ########----------------------------------Email sending logic ----------------------------------#
  def submit(params) do
  httpParams = Poison.encode!(
  %{
  "sender_email" => params.sender_email,
  "recipient_email" => params.recipient_email,
  "subject" => params.subject,
  "senderid" => params.senderid,
  "recipient" => params.recipient,
  "mail_body" => params.mail_body,
  "msg_ref" => params.msg_ref,

  }
  )
  httpurl = "https://probasesms.com/text/multi/res/trns/sms?username=smspbs@123$$&password=pbs@sms123$$&mobiles=260970940309&message=UAT testing Fund Management System&sender=Probase&type=TEXT&source=FUND"
  case HTTPoison.post(httpurl, httpParams, ["Content-Type": "application/json", "Accept": "application/json"]) do
  {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
  httpResult = convertJsonStringToMap(body)
  case httpResult["response"] do
  "successful" ->
  {:ok, "SENT"}
  _->
  {:ok, "FAILED"}
  end
  {:ok, %HTTPoison.Response{status_code: 404}} -> {:error, "SERVICE_NOT_AVAILABLE"}
  {:error, %HTTPoison.Error{reason: reason}} -> {:error, reason}
  end
  end
  def convertJsonStringToMap(str) do
  Regex.replace(~r/([a-z0-9]+):/, str, "\"\\1\":")
  |> String.replace("'", "\"") |> Poison.decode!
  end
  #--------------------- sms logs creation --------------------#
  end
