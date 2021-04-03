defmodule OptionsBot.TDA.TokenServer do
  use GenServer

  alias OptionsBot.TDA.Client

  require Logger

  @default_refresh_rate 20 * 60 * 1000

  # Client

  def start_link(opts \\ []) do
    {name, opts} = Keyword.pop(opts, :name, __MODULE__)
    GenServer.start_link(__MODULE__, opts, name: name)
  end

  def get_access_token(name \\ __MODULE__) do
    GenServer.call(name, :get)
  end

  # Server

  @impl true
  def init(opts) do
    access_token =
      if Application.get_env(:options_bot, :env) != :test do
        retrieve_access_token()
      else
        nil
      end

    refresh_rate = Keyword.get(opts, :refresh_rate, @default_refresh_rate)
    schedule_refresh(refresh_rate)

    {:ok, %{access_token: access_token, refresh_rate: refresh_rate}}
  end

  @impl true
  def handle_call(:get, _from, %{access_token: access_token} = state) do
    {:reply, access_token, state}
  end

  @impl true
  def handle_info(:refresh, %{refresh_rate: refresh_rate} = state) do
    access_token = retrieve_access_token()
    schedule_refresh(refresh_rate)
    {:noreply, Map.put(state, :access_token, access_token)}
  end

  # Private

  defp retrieve_access_token() do
    Logger.info("Retrieving access token")

    :options_bot
    |> Confex.get_env(:tda_refresh_token)
    |> Client.get_access_token()
    |> case do
      {:ok, %{"access_token" => access_token}} ->
        Logger.info("Retrieved access token")
        access_token

      error ->
        Logger.error("Failed retrieving access token: #{inspect(error)}")
        nil
    end
  end

  defp schedule_refresh(rate) do
    Process.send_after(self(), :refresh, rate)
  end
end
