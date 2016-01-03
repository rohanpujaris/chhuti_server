defmodule ChhutiServer.Plugs.GoogleAuthTest do
  use ExUnit.Case

  test "get_url(:token_info, access_token) return tokeninfo url" do
    url = ChhutiServer.Plugs.GoogleAuth.get_url(:token_info, "access_token")
    assert url == "https://www.googleapis.com/oauth2/v2/tokeninfo?access_token=access_token"
  end

  test "get_url(:user_details, access_token) returns url to get user details" do
    url = ChhutiServer.Plugs.GoogleAuth.get_url(:user_details, "access_token")
    assert url == "https://www.googleapis.com/oauth2/v2/userinfo?access_token=access_token"
  end
end
