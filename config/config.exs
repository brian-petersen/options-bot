# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :options_bot, :env, config_env()

config :options_bot,
  tda_client_id: {:system, "TDA_CLIENT_ID"},
  tda_refresh_token: {:system, "TDA_REFRESH_TOKEN"}

config :options_bot,
  ecto_repos: [OptionsBot.Repo]

# Configures the endpoint
config :options_bot, OptionsBotWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "yxC3AN5wjbSPBVb752qRHVcZ9A1NE01c+hS96DEruQy1RvPra168z7W863jwm4Qz",
  render_errors: [view: OptionsBotWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: OptionsBot.PubSub,
  live_view: [signing_salt: "zPzmIrxy"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Other
config :tesla, :adapter, Tesla.Adapter.Hackney

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
