defmodule Spyfall.Game do
  use GenServer

  ## Client API
  def start_link(players) do
    GenServer.start_link(__MODULE__, :ok, [players])
  end

  ## Server

  def init(:ok, players) do
  end
end
