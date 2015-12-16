defmodule ChhutiServer.PageController do
  use ChhutiServer.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
