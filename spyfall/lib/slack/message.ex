defmodule Slack.Message do
  use HTTPotion.Base

  @url "https://slack.com/api/chat.postMessage"
  @token Application.get_env(:spyfall, :token)

  def to_user(username, message) do
    Task.async(fn ->
      post @url, [
        body: encode_body(%{
          text: message,
          channel: "@#{username}",
          token: @token,
          as_user: "true",
        }),
        headers: ["Content-Type": "application/x-www-form-urlencoded"]
      ]
    end)
  end

  defp encode_body(body) do
    params = Enum.map(body, fn {key, value} ->
      "#{key}=#{URI.encode_www_form(value)}"
    end)

    Enum.join(params, "&")
  end
end
