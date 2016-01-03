# TODO: Add docs
defmodule ChhutiServer.Plug.GoogleAuth do
  import Plug.Conn
  import ChhutiServer.Mocker

  mock_for_test ChhutiServer.Plug.GoogleAuthRequest

  def init(_) do
  end

  def call(conn, _) do
    verify_token_and_get_user_details(conn)
  end

  def verify_token_and_get_user_details(%Plug.Conn{assigns: %{access_token: access_token}}=conn) do
    google_client_id = Application.get_env(:chhuti_server, :google_client_id)
    case @google_auth_request.token_info(access_token) do
      {:ok, %{"issued_to" => ^google_client_id}} -> getUserDetails(conn)
      _ -> assign(conn, :google_auth_failure, "Invalid access_token")
    end
  end

  def verify_token_and_get_user_details(conn) do
    assign(conn, :google_auth_failure, "Please send access_token with request")
  end

  def getUserDetails(%Plug.Conn{assigns: %{access_token: access_token}} = conn) do
    case @google_auth_request.user_details(access_token) do
      {:ok, %{"email" => email, "name" => name, "picture" => picture}} ->
        assign(conn, :google_auth_success, %{name: name, email: email, picture: picture})
      {:ok, %{"error" => %{"message" => error_message}}} ->
        assign(conn, :google_auth_failure, error_message)
    end
  end

  defmacro __using__(_) do
    quote do
      plug ChhutiServer.Plug.GetAcessToken
      plug ChhutiServer.Plug.GoogleAuth
      @behaviour ChhutiServer.Behaviour.GoogleAuth
    end
  end
end

defmodule ChhutiServer.Behaviour.GoogleAuth do
  @callback callback(Plug.Conn.t, map) :: any
end
