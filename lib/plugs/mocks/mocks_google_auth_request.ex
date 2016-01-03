defmodule ChhutiServer.Plugs.Mocks.GoogleAuthRequest do

  def token_info_response do
    %{
       "issued_to": "407408718192.apps.googleusercontent.com",
       "audience": "407408718192.apps.googleusercontent.com",
       "user_id": "115781493403455369311",
       "scope": "https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/plus.me",
       "expires_in": 3547,
       "email": "rohan.pujari@kiprosh.com",
       "verified_email": true,
       "access_type": "offline"
    }
  end

  def user_details_response do
    %{
       "id": "115781493403455369311",
       "email": "rohan.pujari@kiprosh.com",
       "verified_email": true,
       "name": "Rohan Pujari",
       "given_name": "Rohan",
       "family_name": "Pujari",
       "link": "https://plus.google.com/115781493403455369311",
       "picture": "https://lh3.googleusercontent.com/-Pr8DsTuSeos/AAAAAAAAAAI/AAAAAAAAACk/5zUetzhQ9Fw/photo.jpg",
       "gender": "male",
       "hd": "kiprosh.com"
    }
  end

  def token_info(access_token) do
    mock_data = Application.get_env(:chhuti_server, :google_auth_mock_data)
    cond do
      access_token == mock_data[:valid_token_for_kiprosher_email] ->
        client_id = Application.get_env(:chhuti_server, :google_client_id)
        %{token_info_response | issued_to: client_id, audience: client_id}
      access_token == mock_data[:valid_token_for_non_kiprosher_email] ->
        token_info_response
    end
  end


end
