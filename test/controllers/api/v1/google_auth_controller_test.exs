defmodule ChhutiServer.Api.V1.GoogleAuthControllerTest do
  use ChhutiServer.ConnCase
  alias ChhutiServer.User

  test "returns error when no access token is passed as params" do
    conn = get conn(), "/api/v1/google_auth/callback"
    assert json_response(conn, 401)["error"] == "Please send access token with request"
  end

  test "returns error when invalid access token is passed as params" do
    conn = get conn(), "/api/v1/google_auth/callback?access_token=invalid"
    assert json_response(conn, 401)["error"] == "Invalid access token"
  end

  test "returns valid token when auth sucessfull and email is of kiprosh.com domain" do
    conn = get conn(), "/api/v1/google_auth/callback?access_token=kiprosh_email"
    assert Map.has_key?(json_response(conn, 200), "token")
  end

  test "returns error when auth sucessfull but email is not from kiprosh.com domain" do
    conn = get conn(), "/api/v1/google_auth/callback?access_token=non_kiprosh_email"
    assert json_response(conn, 422)["error"] == %{"email" => "Email id must be from kiprosh domain"}
  end

  test "creates a user record when auth sucessfull and email is of kiprosh.com domain"do
    user_mock_data = valid_token_data.kiprosh_email
    get conn(), "/api/v1/google_auth/callback?access_token=kiprosh_email"
    user = Repo.one(User |> order_by(desc: :updated_at) |> limit(1))
    assert user.name == user_mock_data.name
    assert user.email == user_mock_data.email
    assert user.picture == user_mock_data.picture
  end

  defp valid_token_data do
    Application.get_env(:google_auth, :mock_data)[:valid_token_data]
  end
end