defmodule ChhutiServer.Api.V1.GoogleAuthController do
  use ChhutiServer.Web, :controller
  use ChhutiServer.Plugs.GoogleAuth

  import ChhutiServer.Mocker

  mock_for_test ChhutiServer.Plugs.GoogleAuth

  plug ChhutiServer.Plugs.GetAcessToken
  plug @google_auth

  alias ChhutiServer.User

  def callback(%Plug.Conn{assigns: %{google_auth_success: user_details}} = conn, _) do
    if user = Repo.get_by(User, %{email: user_details.email}) do
      json conn, %{token: Phoenix.Token.sign(conn, "user", %{user_id: user.id})}
    else
      changeset = User.changeset(%User{}, user_details)
      case Repo.insert(changeset) do
        {:ok, user} ->
          json conn, %{token: Phoenix.Token.sign(conn, "user", %{user_id: user.id})}
        {:error, %{errors: errors}} ->
          conn
          |> put_status(422)
          |> json %{error: Enum.into(errors, %{})}
      end
    end
  end

  def callback(%Plug.Conn{assigns: %{google_auth_failure: error_message}} = conn, _) do
    conn
    |> put_status(401)
    |> json %{error: error_message}
  end
end