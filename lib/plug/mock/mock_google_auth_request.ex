defmodule ChhutiServer.Plug.Mock.GoogleAuthRequest do

  def token_info_response(client \\ :invalid_client) do
    if client == :valid_client do
      client_id = Application.get_env(:chhuti_server, :google_client_id)
    else
      client_id = "407408718192.apps.googleusercontent.com"
    end
    %{
      "issued_to" => client_id,
      "audience" => client_id,
      "user_id" => "115781493403455369311",
      "scope" => "https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/plus.me",
      "expires_in" => 3547,
      "email" => "rohan@kiprosh.com",
      "verified_email" => true,
      "access_type" => "offline"
    }
  end

  def user_details_response(domain \\ :other) do
    mock_data = Application.get_env(:chhuti_server, :google_auth_mock_data)
    mock_data = if domain == :kiprosh do
      mock_data[:user_details_for_kiprosher_email]
    else
      mock_data[:user_details_for_non_kiprosher_email]
    end
    Map.merge(mock_data,
      %{
        "id" => "115781493403455369311",
        "verified_email" => true,
        "given_name" => "Rohan",
        "family_name" => "Pujari",
        "link" => "https://plus.google.com/115781493403455369311",
        "gender" => "male",
        "hd" => "kiprosh.com"
      }
    )
  end

  def token_info(access_token) do
    mock_data = Application.get_env(:chhuti_server, :google_auth_mock_data)
    cond do
      access_token == mock_data[:valid_token_for_kiprosher_email] ||
      access_token == mock_data[:valid_token_for_non_kiprosher_email] ->
        {:ok, token_info_response(:valid_client)}
      access_token == mock_data[:valid_token_from_invalid_client_id] ->
        {:ok, token_info_response}
      :invalid_token ->
        %{errors: "Invalid token"}
    end
  end

  def user_details(access_token) do
    mock_data = Application.get_env(:chhuti_server, :google_auth_mock_data)
    cond do
      access_token == mock_data[:valid_token_for_kiprosher_email] ->
        {:ok, user_details_response(:kiprosh)}
      access_token == mock_data[:valid_token_for_non_kiprosher_email] ->
        {:ok, user_details_response}
    end
  end
end
