import Config

config :options_bot,
  tda_client_id: "client_id",
  tda_refresh_token: "refresh_token"

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :options_bot, OptionsBot.Repo,
  username: "postgres",
  password: "postgres",
  database: "options_bot_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :options_bot, OptionsBotWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Other
config :tesla, adapter: TeslaMock
