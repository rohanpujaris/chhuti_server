defmodule ChhutiServer.Api.V1.GoogleAuthController do
  import ModuleMocker

  use ChhutiServer.Web, :controller
  use GoogleAuth

  alias ChhutiServer.User

  def callback(%Plug.Conn{private: %{google_auth_success: user_details}} = conn, _) do
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

  def callback(%Plug.Conn{private: %{google_auth_failure: error_message}} = conn, _) do
    conn
      |> put_status(401)
      |> json %{error: error_message}
  end
end
