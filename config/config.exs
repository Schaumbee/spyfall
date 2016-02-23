use Mix.Config

config :spyfall,
token: "",
channel: "spyfall",
min_players: 3

import_config "content.exs"
import_config "#{Mix.env}.exs"

unless Mix.env == :prod do
  import_config "secret.exs"
end
