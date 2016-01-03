defmodule ChhutiServer.Api.V1.GoogleAuthControllerTest do
  use ChhutiServer.ConnCase
  alias ChhutiServer.User

  setup do
    {:ok, mock_data: Application.get_env(:chhuti_server, :google_auth_mock_data)}
  end

  test "returns error when no access token is passed as params" do
    conn = get conn(), "/api/v1/google_auth/callback"
    assert json_response(conn, 401)["error"] == "Please send access_token with request"
  end

  test "returns error when invalid access token is passed as params", %{mock_data: mock_data} do
    token = mock_data[:invalid_token]
    conn = get conn(), "/api/v1/google_auth/callback?access_token=#{token}"
    assert json_response(conn, 401)["error"] == "Invalid access_token"
  end

  test "returns valid token when auth sucessfull and email is of kiprosh.com domain", %{mock_data: mock_data} do
    token = mock_data[:valid_token_for_kiprosher_email]
    conn = get conn(), "/api/v1/google_auth/callback?access_token=#{token}"
    assert Map.has_key?(json_response(conn, 200), "token")
  end

  test "returns error when auth sucessfull but email is not from kiprosh.com domain", %{mock_data: mock_data} do
    token = mock_data[:valid_token_for_non_kiprosher_email]
    conn = get conn(), "/api/v1/google_auth/callback?access_token=#{token}"
    assert json_response(conn, 422)["error"] == %{"email" => "Email id must be from kiprosh domain"}
  end

  test "creates a user record when auth sucessfull and email is of kiprosh.com domain", %{mock_data: mock_data} do
    token = mock_data[:valid_token_for_kiprosher_email]
    get conn(), "/api/v1/google_auth/callback?access_token=#{token}"
    user = Repo.one(User |> order_by(desc: :updated_at) |> limit(1))
    user_mock_data = mock_data[:user_details_for_kiprosher_email]
    assert user.name == user_mock_data.name
    assert user.email == user_mock_data.email
    assert user.picture == user_mock_data.picture
  end
end