defmodule Spyfall.Bot do
  use Slack

  @channel Application.get_env(:spyfall, :channel)

  def handle_connect(slack, state) do
    IO.puts "Connected as #{slack.me.name}"

    chan = find_channel_id(slack.channels)
    users = map_user_ids_to_names(slack.users)
    {:ok, loop} = Spyfall.GameLoop.start_link

    {:ok, {loop, users, chan}}
  end

  def handle_message(%{type: "message", text: text, user: user}, slack, game) do
    {loop, users, chan} = game

    username = users[user]
    responses = Spyfall.GameLoop.respond(loop, username, text)

    Enum.each(responses, fn response ->
      case response do
        {:broadcast, message} ->
          IO.puts "BROADCAST: #{message}"
        {:private, {user, message}} ->
          IO.puts "PRIVATE TO: #{user}, MESSAGE: #{message}"
      end
    end)

    {:ok, game}
  end

  def handle_message(message, _slack, game) do
    IO.puts inspect message
    {:ok, game}
  end

  defp find_channel_id(channels) do
    # TODO: What if the channel doesn't exist?
    {id, _} = Enum.find(channels, fn {id, channel} ->
      channel.name == @channel
    end)

    id
  end

  defp map_user_ids_to_names(users) do
    Enum.reduce(users, %{}, fn {id, user}, acc ->
      Map.put(acc, id, user.name)
    end)
  end
end
