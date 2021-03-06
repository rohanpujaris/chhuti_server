# TODO: Add docs, support token in header, find way to create current_user method, add tests
defmodule ChhutiServer.Plug.Authentication do
  import Plug.Conn
  import Phoenix.Controller, only: [json: 2]
  import ChhutiServer.User

  def init(_) do
  end

  def call(%Plug.Conn{params: %{"access_token" => access_token}} = conn, _) do
    case Phoenix.Token.verify(conn, "user", access_token, max_age: 1209600) do
      {:ok, %{user_id: user_id}} -> assign(conn, :current_user, Repo.get(User, user_id))
      {:error, reason} ->
        message = if reason == :expired do
          "Access token expired. Please login again"
        else
          "Authentication failed"
        end
        conn
        |> json(%{error: message})
        |> halt
    end
  end

  def call(conn, _) do
    conn
    |> put_status(401)
    |> json(%{error: "Authentication failed"})
    |> halt
  end

  defmacro __using__(_) do
    quote do
      import ChhutiServer.Plug.Authentication
    end
  end
end
