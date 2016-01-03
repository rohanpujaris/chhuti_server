defmodule ChhutiServer.Plugs.Mocks.GoogleAuth do
  import Plug.Conn

  def init([]) do
  end

  def call(%Plug.Conn{assigns: %{access_token: access_token}}=conn, _) do
    mock_data = Application.get_env(:chhuti_server, :google_auth_mock_data)
    cond do
      access_token == mock_data[:valid_token_for_kiprosher_email] ->
        assign(conn, :google_auth_success, mock_data[:user_details_for_kiprosher_email])
      access_token == mock_data[:valid_token_for_non_kiprosher_email] ->
        assign(conn, :google_auth_success, mock_data[:user_details_for_non_kiprosher_email])
      access_token == mock_data[:invalid_token] ->
        assign(conn, :google_auth_failure, "Invalid access_token")
    end
  end

  def call(conn, _) do
    assign(conn, :google_auth_failure, "Please send access_token with request")
  end
end
