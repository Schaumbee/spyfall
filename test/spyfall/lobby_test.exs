defmodule Spyfall.LobbyTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, lobby} = Spyfall.Lobby.start_link
    {:ok, lobby: lobby}
  end

  test "players can be added to lobby", %{lobby: lobby} do
    assert length(Spyfall.Lobby.players(lobby)) == 0

    assert :ok = Spyfall.Lobby.join(lobby, "player1")
    assert length(Spyfall.Lobby.players(lobby)) == 1

    assert :ok = Spyfall.Lobby.join(lobby, "player2")
    assert length(Spyfall.Lobby.players(lobby)) == 2
  end

  test "player cannot be added to lobby more than once", %{lobby: lobby} do
    Spyfall.Lobby.join(lobby, "player1")

    assert {:error, message} = Spyfall.Lobby.join(lobby, "player1")

    assert message == "player1 is already in the lobby"
    assert length(Spyfall.Lobby.players(lobby)) == 1
  end

  test "players can leave lobby", %{lobby: lobby} do
    Spyfall.Lobby.join(lobby, "player1")
    Spyfall.Lobby.join(lobby, "player2")

    Spyfall.Lobby.leave(lobby, "player1")

    assert Spyfall.Lobby.players(lobby) == ["player2"]
  end

  test "players cannot leave lobby when not joined", %{lobby: lobby} do
    assert {:error, message} = Spyfall.Lobby.leave(lobby, "player1")
    assert message == "player1 is not in the lobby"
  end

  test "game cannot start without minimum number of people", %{lobby: lobby} do
    min = Application.get_env(:spyfall, :min_players)

    for x <- 1..(min - 1) do
      Spyfall.Lobby.join(lobby, "player#{x}")
    end

    assert {:error, message} = Spyfall.Lobby.start_game(lobby)
    assert message == "At least #{min} players are needed to start"

    Spyfall.Lobby.join(lobby, "final player")
    assert {:ok, _} = Spyfall.Lobby.start_game(lobby)
  end
end
