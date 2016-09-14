defmodule CrambearPhoenix.Router do
  use CrambearPhoenix.Web, :router
  require Sentinel

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug :accepts, ["json","json-api"]
  end

  scope "/", CrambearPhoenix do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end


  # This pipeline if intended for API requests and looks for the JWT in the "Authorization" header
  # In this case, it should be prefixed with "Bearer" so that it's looking for
  # Authorization: Bearer <jwt>
  pipeline :api_auth do
    plug :accepts, ["json","json-api"]
    plug JaSerializer.ContentTypeNegotiation
    plug JaSerializer.Deserializer
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.EnsureAuthenticated, %{ handler: Application.get_env(:sentinel, :auth_handler) || Sentinel.AuthHandler }
    plug Guardian.Plug.LoadResource
    plug CrambearPhoenix.Plug.CurrentUser
  end


  scope "/api" do
    pipe_through :api
    post "/register", CrambearPhoenix.Api.RegistrationController, :create
    get "/me", CrambearPhoenix.Api.UserController, :show
    post "/sessions", CrambearPhoenix.Api.SessionController, :create
    delete "/sessions", CrambearPhoenix.Api.SessionController, :delete
    get "/cardsets", CrambearPhoenix.Api.CardsetController, :index
    Sentinel.mount_api

  end

  scope "/api", CrambearPhoenix do
    pipe_through [:api_auth]
    resources "/cardsets", Api.CardsetController
    resources "/cards", Api.CardController
  end
end
