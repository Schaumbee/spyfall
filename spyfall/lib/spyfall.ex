defmodule Spyfall do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # worker(Spyfall.Bot, ["xoxb-21349507894-PV968wLa21qEt3oqNjQiTigF", []])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Spyfall.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
