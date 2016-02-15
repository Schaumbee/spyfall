defmodule Spyfall.GameLoop do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ok)
  end

  def respond(game, player, message) do
    if message =~ ~r/^start$/ do
      GenServer.call(game, :start)
    else
      GenServer.call(game, {:message, player, message})
    end
  end

  # Server (callback)

  def init(:ok) do
    {:ok, lobby} = Spyfall.Lobby.start_link
    {:ok, {:lobby, lobby}}
  end

  def handle_call(:start, _from, {:lobby, lobby} = state) do
    players = Spyfall.Lobby.players(lobby)
    case Spyfall.Game.start_link(players) do
      {:ok, game} ->
        start = {:broadcast, "Starting the game"}
        roles = for role <- Spyfall.Game.player_roles(game) do
          {:private, role}
        end

        {:reply, [start|roles], {:game, game}}
      {:error, error} ->
        {:reply, [{:broadcast, error}], state}
    end
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
        # TODO: this should just crash instead of fall back to nil
        nil
    end

    {:reply, [{:broadcast, reply}], state}
  end

  def handle_call({:message, player, message}, _from, {:game, game} = state) do
    {:reply, [{:broadcast, "In the game"}], state}
  end

  def handle_call(:start, _from, {:game, game} = state) do
    {:reply, [{:broadcast, "There is already a game being played"}], state}
  end
end
