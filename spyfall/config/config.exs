use Mix.Config

config :spyfall,
token: "",
channel: "spyfall",
min_players: 3

import_config "#{Mix.env}.exs"
import_config "content.exs"
import_config "secret.exs"
