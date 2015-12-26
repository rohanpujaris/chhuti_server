# TODO: Add docs
defmodule ChhutiServer.Plugs.GoogleAuth do
  import Plug.Conn

  @google_urls [
    base_url: "https://www.googleapis.com/oauth2/v2",
    token_info: "/tokeninfo",
    user_details: "/userinfo"
  ]

  defmodule ChhutiServer.Behaviour.GoogleAuth do
    @callback callback(Plug.Conn.t, map) :: any
  end

  def init(_) do
  end

  def call(conn, _)do
    verify_token_and_get_user_details(conn)
  end

  def get_url(api_path, access_token) do
    "#{@google_urls[:base_url]}#{@google_urls[api_path]}?access_token=#{access_token}"
  end

  def verify_token_and_get_user_details(%Plug.Conn{assigns: %{access_token: access_token}}=conn) do
    response = HTTPotion.get(get_url(:token_info, "access_token"))
    google_client_id = Application.get_env(:chhuti_server, :google_client_id)
    case Poison.decode(response.body) do
      {:ok, %{"issued_to" => ^google_client_id}} -> getUserDetails(conn)
      _ -> assign(conn, :google_auth_failure, "Invalid access_token")
    end
  end

  def verify_token_and_get_user_details(conn) do
    assign(conn, :google_auth_failure, "Please send access_token with request")
  end

  def getUserDetails(%Plug.Conn{params: %{"access_token" => access_token}} = conn) do
    response = HTTPotion.get(get_url(:user_details, access_token))
    case Poison.decode(response.body) do
      {:ok, %{"email" => email, "name" => name, "picture" => picture}} ->
        assign(conn, :google_auth_success, %{name: name, email: email, picture: picture})
      {:ok, %{"error" => %{"message" => error_message}}} ->
        assign(conn, :google_auth_failure, error_message)
    end
  end

  defmacro __using__(_) do
    quote do
      plug ChhutiServer.Plugs.GetAcessToken
      plug ChhutiServer.Plugs.GoogleAuth
      @behaviour ChhutiServer.Behaviour.GoogleAuth
    end
  end
end
