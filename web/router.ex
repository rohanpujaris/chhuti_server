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

  scope "/", ChhutiServer do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", ChhutiServer do
    pipe_through :api

    get "/google_auth/callback", GoogleAuthController, :callback
  end
end
