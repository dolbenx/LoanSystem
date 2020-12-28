defmodule FundsMgt.Workers.ProbaseGateway do
  alias FundsMgt.Settings


  def send(sms) do
    process_sm(sms)
  end

  defp process_sm(sms) do
    case Settings.gateway_configs() do
      nil ->
        {:error, "Gateway configurarions not found"}
      gateway_configs ->
        sms_params = prepare_sm_params(sms, gateway_configs)
        headers = [{"Content-Type", "application/json"}]
        options = [timeout: 50_000, recv_timeout: 60_000, hackney: [:insecure]]
        HTTPoison.post(String.trim(gateway_configs.single_sms_url), Poison.encode!(sms_params), headers, options)
    end
  end

  defp prepare_sm_params(sms, gateway_configs) do
    %{
      message: sms.msg,
      recipient: ["#{String.trim(sms.mobile)}"],
      senderid: String.trim(gateway_configs.sender_id),
      username: String.trim(gateway_configs.username),
      password: String.trim(gateway_configs.password)
    }
  end

end
