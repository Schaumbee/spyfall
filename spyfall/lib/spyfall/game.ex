defmodule Spyfall.Game do
  use GenServer

  @min_players Application.get_env(:spyfall, :min_players)
  @locations Application.get_env(:spyfall, :locations)

  ## Client API

  def start_link(player_names) do
    if length(player_names) < @min_players do
      {:error, "At least #{@min_players} players are needed to start the game"}
    else
      GenServer.start_link(__MODULE__, player_names)
    end
  end

  def guess_spy(game, player, guess) do
    GenServer.call(game, {:guess_spy, player, guess})
  end

  def guess_location(game, player, guess) do
    GenServer.call(game, {:guess_location, player, guess})
  end

  def players(game) do
    GenServer.call(game, :players)
  end

  def player_roles(game) do
    GenServer.call(game, :roles)
  end

  ## Server (callback)

  def init(player_names) do
    {location, roles} = Enum.random(@locations)
    players = assign_roles(player_names, roles)

    {:ok, {location, players}}
  end

  def handle_call({:guess_spy, player, guess}, _from, {_, players} = state) do
    spy_player = spy(players)

    reply = cond do
      player == spy_player ->
        {:error, "The spy cannot guess the spy"}
      guess == spy_player ->
        {:ok, :correct, spy_player}
      Map.has_key?(players, guess) ->
        {:ok, :incorrect, spy_player}
      true ->
        {:error, "#{guess} is not playing the game"}
    end

    {:reply, reply, state}
  end

  def handle_call({:guess_location, player, guess}, _from, {location, players} = state) do
    spy_player = spy(players)
    valid_location? = Enum.any?(@locations, fn {name, _} ->
      String.downcase(name) == String.downcase(guess)
    end)

    reply = cond do
      player != spy_player ->
        {:error, "Only the spy can guess the location"}
      String.downcase(guess) == String.downcase(location) ->
        {:ok, :correct, location}
      valid_location? ->
        {:ok, :incorrect, location}
      true ->
        {:error, "#{guess} is not a valid location"}
    end

    {:reply, reply, state}
  end

  def handle_call(:players, _from, {_, players} = state) do
    {:reply, players, state}
  end

  def handle_call(:roles, _from, {location, players} = state) do
    roles = for {name, role} <- players do
      desc = if role == :spy do
        "You are the spy!"
      else
        "Location: #{location}; your role: #{role}"
      end

      {name, desc}
    end

    {:reply, roles, state}
  end

  defp assign_roles(player_names, roles) do
    [spy|rest] = Enum.shuffle(player_names)
    Map.put(assign_non_spy_roles(rest, roles), spy, :spy)
  end

  defp assign_non_spy_roles(names, roles) do
    players_and_roles = Enum.zip(names, Stream.cycle(roles))

    Enum.reduce(players_and_roles, %{}, fn {name, role}, acc ->
      Map.put(acc, name, role)
    end)
  end

  defp spy(players) do
    {name, _} = Enum.find(players, fn {_, role} -> role == :spy end)
    name
  end
end
