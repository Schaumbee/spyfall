defmodule Spyfall.Game do
  use GenServer

  ## Client API

  def start_link(player_names) do
    GenServer.start_link(__MODULE__, player_names)
  end

  def spy(game) do
    GenServer.call(game, :spy)
  end

  def location(game) do
    GenServer.call(game, :location)
  end

  def players(game) do
    GenServer.call(game, :players)
  end

  ## Server

  def init(player_names) do
    {location, roles} = random_location
    players = assign_roles(player_names, roles)

    {:ok, {location, players}}
  end

  def handle_call(:location, _from, {location, _} = state) do
    {:reply, location, state}
  end

  def handle_call(:players, _from, {_, players} = state) do
    {:reply, players, state}
  end

  defp assign_roles(player_names, roles) do
    [spy|rest] = Enum.shuffle(player_names)
    Map.put(assign_non_spy_roles(rest, roles), spy, :spy)
  end

  defp random_location do
    locations = Application.get_env(:spyfall, :locations)
    Enum.random(locations)
  end

  defp assign_non_spy_roles(names, roles) do
    players_and_roles = Enum.zip(names, Stream.cycle(roles))

    Enum.reduce(players_and_roles, %{}, fn {name, role}, acc ->
      Map.put(acc, name, role)
    end)
  end
end
