defmodule Spyfall.Bot do
  use Slack

  def handle_connect(slack, _state) do
    IO.puts "Connected as #{slack.me.name}"

    chan = find_channel_id(slack.channels)
    users = map_user_ids_to_names(slack.users)
    {:ok, loop} = Spyfall.GameLoop.start_link

    {:ok, {loop, users, chan}}
  end

  def handle_message(message = %{type: "message", text: _}, slack, game) do
    if should_reply?(message, game) do
      reply(message, slack, game)
    else
      {:ok, game}
    end

  end

  def handle_message(_message, _slack, game) do
    {:ok, game}
  end

  defp should_reply?(message, {_, _, chan}) do
    # Allow direct messages to be replied to when not in prod
    is_direct_message? = String.starts_with?(message.channel, "D")
    message.channel == chan or (Mix.env != :prod and is_direct_message?)
  end

  defp reply(message, slack, {loop, users, _} = game) do
    username = users[message.user]
    responses = Spyfall.GameLoop.respond(loop, username, message.text)

    Enum.each(responses, fn response ->
      case response do
        {:broadcast, msg} ->
          send_message(msg, message.channel, slack)
        {:private, {name, msg}} ->
          Slack.Message.to_user(name, msg)
      end
    end)

    {:ok, game}
  end

  defp find_channel_id(channels) do
    # TODO: What if the channel doesn't exist?
    name = Application.get_env(:spyfall, :channel)

    {id, _} = Enum.find(channels, fn {_, channel} ->
      channel.name == name
    end)

    id
  end

  defp map_user_ids_to_names(users) do
    Enum.reduce(users, %{}, fn {id, user}, acc ->
      Map.put(acc, id, user.name)
    end)
  end
end
