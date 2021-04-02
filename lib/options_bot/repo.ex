defmodule OptionsBot.Repo do
  use Ecto.Repo,
    otp_app: :options_bot,
    adapter: Ecto.Adapters.Postgres
end
