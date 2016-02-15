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
    IO.puts "RECEIVE MESSAGE: #{text} FROM: #{username}"
    response = Spyfall.GameLoop.respond(loop, username, text)
    IO.puts "SEND MESSAGE: #{response}"
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
