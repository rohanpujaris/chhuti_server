defmodule ChhutiServer.PageController do
  use ChhutiServer.Web, :controller
  plug ChhutiServer.Plugs.Authentication when action in [:index]

  def index(conn, _) do
    render conn, "index.html"
  end
end
