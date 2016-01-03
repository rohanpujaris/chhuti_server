defmodule ChhutiServer.PageController do
  use ChhutiServer.Web, :controller

  def index(conn, _) do
    render conn, "index.html"
  end
end
