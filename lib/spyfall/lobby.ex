defmodule Spyfall.Lobby do
  def start_link do
    Agent.start_link(fn -> HashSet.new end)
  end

  def join(lobby, player) do
    Agent.get_and_update(lobby, fn players ->
      if Set.member?(players, player) do
        {{:error, "#{player} is already in the lobby"}, players}
      else
        {:ok, Set.put(players, player)}
      end
    end)
  end

  def leave(lobby, player) do
    Agent.get_and_update(lobby, fn players ->
      if not Set.member?(players, player) do
        {{:error, "#{player} is not in the lobby"}, players}
      else
        {:ok, Set.delete(players, player)}
      end
    end)
  end

  def players(lobby) do
    Agent.get(lobby, &Set.to_list(&1))
  end

  def teardown(lobby) do
    Agent.stop(lobby)
  end
end
