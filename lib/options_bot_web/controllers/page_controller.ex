defmodule OptionsBotWeb.PageController do
  use OptionsBotWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
