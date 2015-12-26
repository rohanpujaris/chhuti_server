defmodule ChhutiServer.Plugs.GetAcessToken do
  import Plug.Conn
  import Plug.Builder, only: [plug: 1]

  def init(_) do
  end

  def call(conn, _) do
    access_token = conn.params["access_token"] ||
      get_req_header(conn, "authorization")
        |> to_string
        |> String.replace("Token token=", "")
    if access_token != "" do
      conn = assign(conn, :access_token, access_token)
    end
    conn
  end
end
