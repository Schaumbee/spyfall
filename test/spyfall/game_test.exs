defmodule Spyfall.GameTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, game} = Spyfall.Game.start_link(~w(player1 player2 player3 player4))
    {:ok, game: game}
  end

  test "a location is chosen from configuration", %{game: game} do
    assert Spyfall.Game.location(game) == "Location"
  end

  test "all players are assigned a role", %{game: game} do
    roles = ["Role 1", "Role 2"]

    assert Enum.all?(Spyfall.Game.players(game), fn {_, role} ->
      role == :spy || Enum.member?(roles, role)
    end)
  end

  test "all roles are used when there are more players than roles", %{game: game} do
    roles = ["Role 1", "Role 2"]
    player_roles = Map.values(Spyfall.Game.players(game))

    assert Enum.all?(roles, &Enum.member?(player_roles, &1))
  end

  test "exactly one player is the spy", %{game: game} do
    roles = Map.values(Spyfall.Game.players(game))
    spies = Enum.filter(roles, fn role -> role == :spy end)

    assert length(spies) == 1
  end
end
