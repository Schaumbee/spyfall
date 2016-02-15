defmodule Spyfall.Lobby do
  use GenServer

  def start_link(min) do
    GenServer.start_link(__MODULE__, min)
  end

  def join(lobby, player) do
    GenServer.call(lobby, {:join, player})
  end

  def leave(lobby, player) do
    GenServer.call(lobby, {:leave, player})
  end

  def players(lobby) do
    GenServer.call(lobby, :players)
  end

  def start_game(lobby) do
    GenServer.call(lobby, :start)
  end

  ## Server

  def init(min) do
    {:ok, {HashSet.new, min}}
  end

  def handle_call({:join, player}, _from, state) do
    {players, min} = state

    if Set.member?(players, player) do
      {:reply, {:error, "#{player} is already in the lobby"}, state}
    else
      {:reply, :ok, {Set.put(players, player), min}}
    end
  end

  def handle_call({:leave, player}, _from, state) do
    {players, min} = state

    if not Set.member?(players, player) do
      {:reply, {:error, "#{player} is not in the lobby"}, state}
    else
      {:reply, :ok, {Set.delete(players, player), min}}
    end
  end

  def handle_call(:players, _from, {players, _} = state) do
    {:reply, Set.to_list(players), state}
  end

  def handle_call(:start, _from, state) do
    {players, min} = state

    if Set.size(players) < min do
      {:reply, {:error, "At least #{min} players are needed to start"}, state}
    else
      {:reply, Spyfall.Game.start_link(Set.to_list(players)), state}
    end
  end
end
