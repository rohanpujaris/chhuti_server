defmodule ChhutiServer.Plugs.GetAcessToken do
  import Plug.Conn
  import Plug.Builder, only: [plug: 1]

  def init(_) do
  end

  def call(conn, _) do
    access_token = conn.params["access_token"] ||
      get_req_header(conn, "authorization")
        |> to_string
        |> String.replace("\"", "")
        |> String.replace("Token token=", "")
    IO.puts "===================="
    if access_token, do: assign(conn, :access_token, access_token)
  end

  # defmacro __using__(_) do
  #   quote do
  #     import ChhuttiServer.Plugs.GetAcessToken
  #     plug ChhuttiServer.Plugs.GetAcessToken
  #   end
  # end
end
