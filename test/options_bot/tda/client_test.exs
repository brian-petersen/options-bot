defmodule OptionsBot.TDA.ClientTest do
  use OptionsBot.DataCase

  alias OptionsBot.TDA.Client

  test "parses good response" do
    expect(TeslaMock, :call, fn %{url: "https://api.tdameritrade.com/v1/marketdata/AAPL/quotes"},
                                _ ->
      {:ok, json(%{"body" => 1})}
    end)

    assert {:ok, %{"body" => 1}} = Client.get_quote("AAPL")
  end

  test "parses bad response" do
    expect(TeslaMock, :call, fn %{url: "https://api.tdameritrade.com/v1/marketdata/AAPL/quotes"},
                                _ ->
      {:ok, json(%{"error" => 2}, status: 400)}
    end)

    assert {:error, %{"error" => 2}} = Client.get_quote("AAPL")
  end

  test "passes others along" do
    expect(TeslaMock, :call, fn %{url: "https://api.tdameritrade.com/v1/marketdata/AAPL/quotes"},
                                _ ->
      {:error, :nxdomain}
    end)

    assert {:error, :nxdomain} = Client.get_quote("AAPL")
  end
end
