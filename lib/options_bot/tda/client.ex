defmodule OptionsBot.TDA.Client do
  alias OptionsBot.TDA.TokenServer

  def get_access_token(refresh_token) do
    client_no_bearer()
    |> Tesla.post("oauth2/token", %{
      grant_type: "refresh_token",
      refresh_token: refresh_token,
      client_id: get_client_id()
    })
    |> parse_response()
  end

  def get_quote(symbol) do
    client()
    |> Tesla.get("marketdata/#{symbol}/quotes")
    |> parse_response()
  end

  defp client() do
    client(TokenServer.get_access_token())
  end

  defp client(access_token) do
    Tesla.client([
      {Tesla.Middleware.BaseUrl, "https://api.tdameritrade.com/v1"},
      Tesla.Middleware.EncodeFormUrlencoded,
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, [{"Authorization", "Bearer #{access_token}"}]}
    ])
  end

  defp client_no_bearer() do
    Tesla.client([
      {Tesla.Middleware.BaseUrl, "https://api.tdameritrade.com/v1"},
      Tesla.Middleware.EncodeFormUrlencoded,
      Tesla.Middleware.JSON
    ])
  end

  defp get_client_id() do
    Confex.get_env(:options_bot, :tda_client_id)
  end

  defp parse_response({:ok, %{body: body, status: status}}) when status >= 400 do
    {:error, body}
  end

  defp parse_response({:ok, %{body: body}}) do
    {:ok, body}
  end

  defp parse_response(response) do
    response
  end
end
