defmodule Spyfall.GameLoop do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ok)
  end

  def respond(game, player, message) do
    IO.puts "doing a call"
    GenServer.call(game, {:message, player, message})
  end

  # Server (callback)

  def init(:ok) do
    {:ok, lobby} = Spyfall.Lobby.start_link
    {:ok, {:lobby, lobby}}
  end

  def handle_call({:message, player, message}, _from, {:lobby, lobby} = state) do
    reply = cond do
      message =~ ~r/^lobby$/ ->
        case Spyfall.Lobby.players(lobby) do
          [] ->
            "No one is waiting to play the next game"
          players ->
            "Here are the players waiting for the next game: #{Enum.join(players, ", ")}"
        end
      message =~ ~r/^join$/ ->
        case Spyfall.Lobby.join(lobby, player) do
          :ok             -> "#{player} has joined the game"
          {:error, error} -> error
        end
      message =~ ~r/^leave$/ ->
        case Spyfall.Lobby.leave(lobby, player) do
          :ok             -> "#{player} has left the game"
          {:error, error} -> error
        end
      true ->
        nil
    end

    {:reply, reply, state}
  end

  def handle_call({:message, message}, _from, {:game, game} = state) do
    {:reply, "game", state}
  end
end
