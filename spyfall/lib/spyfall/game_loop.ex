defmodule Spyfall.GameLoop do
  use GenServer

  @location_guess ~r/^location:\s*(?<location>[a-zA-Z ]+)$/i
  @spy_guess ~r/^@?(?<spy>\w+):? is the spy!?$/i

  def start_link do
    GenServer.start_link(__MODULE__, :ok)
  end

  def respond(game, player, message) do
    if message =~ ~r/^start$/i do
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
      message =~ ~r/^lobby$/i ->
        case Spyfall.Lobby.players(lobby) do
          [] ->
            "No one is waiting to play the next game"
          players ->
            "Here are the players waiting for the next game: #{Enum.join(players, ", ")}"
        end
      message =~ ~r/^join$/i ->
        case Spyfall.Lobby.join(lobby, player) do
          :ok             -> "#{player} has joined the game"
          {:error, error} -> error
        end
      message =~ ~r/^leave$/i ->
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

  def handle_call({:message, player, message}, _from, state) do
    cond do
      message =~ @location_guess ->
        guess = Regex.named_captures(@location_guess, message)["location"]
        guess_location(state, player, guess)
      message =~ @spy_guess ->
        guess = Regex.named_captures(@spy_guess, message)["spy"]
        guess_spy(state, player, guess)
      true ->
        {:reply, [], state}
    end
  end

  def handle_call(:start, _from, state) do
    {:reply, [{:broadcast, "There is already a game being played"}], state}
  end

  defp guess_location({:game, game} = state, player, guess) do
    case Spyfall.Game.guess_location(game, player, guess) do
      {:ok, :correct, _} ->
        finish_game("Good work, Agent #{player}! I knew we could count on you.")
      {:ok, :incorrect, location} ->
        finish_game("You blew your cover, Agent #{player}! The correct location was: #{location}")
      {:error, msg} ->
        IO.puts "ERROR: #{msg}"
        {:reply, [], state}
    end
  end

  defp guess_spy({:game, game} = state, player, guess) do
    case Spyfall.Game.guess_spy(game, player, guess) do
      {:ok, :correct, name} ->
        finish_game("You're right! #{name} is the spy!")
      {:ok, :incorrect, name} ->
        finish_game("You're wrong! #{guess} isn't the spy; #{name} is the spy!")
      {:error, msg} ->
        IO.puts "ERROR: #{msg}"
        {:reply, [], state}
    end
  end

  defp finish_game(message) do
    {:ok, new_lobby} = Spyfall.Lobby.start_link
    {:reply, [{:broadcast, message}], {:lobby, new_lobby}}
  end
end
