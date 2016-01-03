defmodule ChhutiServer.Router do
  use ChhutiServer.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :mandatory_authentication_api_endpoints do
    plug :accepts, ["json"]
    plug ChhutiServer.Plug.Authentication
  end

  scope "/", ChhutiServer do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Below endpoints won't require authetication
  scope "/api", ChhutiServer.Api do
    pipe_through :api
    scope "/v1", V1 do
      get "/google_auth/callback", GoogleAuthController, :callback
    end
  end

  # Below endpoints would require authentication
  scope "/api", ChhutiServer.Api do
    pipe_through :mandatory_authentication_api_endpoints
    scope "/v1", V1 do
    end
  end
end
