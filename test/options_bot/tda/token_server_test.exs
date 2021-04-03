defmodule OptionsBot.TDA.TokenServerTest do
  use OptionsBot.DataCase

  alias OptionsBot.TDA.TokenServer

  test "refreshes token after specified time" do
    TokenServer.start_link(name: __MODULE__, refresh_rate: 50)

    allow(TeslaMock, self(), __MODULE__)

    expect(TeslaMock, :call, fn %{url: "https://api.tdameritrade.com/v1/oauth2/token"}, _ ->
      {:ok, json(%{"access_token" => "token1"})}
    end)

    expect(TeslaMock, :call, fn %{url: "https://api.tdameritrade.com/v1/oauth2/token"}, _ ->
      {:ok, json(%{"access_token" => "token2"})}
    end)

    # give time for refresh to be hit
    Process.sleep(60)
    assert "token1" == TokenServer.get_access_token(__MODULE__)

    # give time for refresh to be hit again
    Process.sleep(60)
    assert "token2" == TokenServer.get_access_token(__MODULE__)
  end

  test "token set to nil if fails to load" do
    TokenServer.start_link(name: __MODULE__, refresh_rate: 50)

    allow(TeslaMock, self(), __MODULE__)

    expect(TeslaMock, :call, fn %{url: "https://api.tdameritrade.com/v1/oauth2/token"}, _ ->
      {:ok, json(%{"access_token" => "token1"})}
    end)

    expect(TeslaMock, :call, fn %{url: "https://api.tdameritrade.com/v1/oauth2/token"}, _ ->
      {:ok, json(%{"error" => "doy"}, status: 401)}
    end)

    # give time for refresh to be hit
    Process.sleep(60)
    assert "token1" == TokenServer.get_access_token(__MODULE__)

    # give time for refresh to be hit again
    Process.sleep(60)
    assert nil == TokenServer.get_access_token(__MODULE__)
  end
end
