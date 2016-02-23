use Mix.Config

config :spyfall,
  token: System.get_env("SLACK_TOKEN"),
  channel: System.get_env("SLACK_CHANNEL")
