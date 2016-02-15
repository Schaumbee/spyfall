defmodule Spyfall.Bot do
  use Slack

  def handle_connect(slack, state) do
    IO.puts "Connected as #{slack.me.name}"
    {:ok, state}
  end

  def handle_message(message = %{type: "message"}, slack, state) do
    cond do
      message.text =~ ~r/^join$/ ->
        IO.puts "join the game"
      message.text =~ ~r/^leave$/ ->
        IO.puts "leave the game"
      true ->
        IO.puts "do nothing"
    end

    {:ok, state}
  end

  def handle_message(_message, _slack, state) do
    IO.puts "Got a different type of message"
    {:ok, state}
  end
end
