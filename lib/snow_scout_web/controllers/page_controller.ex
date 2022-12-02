defmodule SnowScoutWeb.PageController do
  use SnowScoutWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
