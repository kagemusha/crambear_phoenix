defmodule CrambearPhoenix.Router do
  use CrambearPhoenix.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json-api"]
    plug JaSerializer.ContentTypeNegotiation
    plug JaSerializer.Deserializer
  end

  scope "/", CrambearPhoenix do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end


  scope "/api", CrambearPhoenix do
    pipe_through :api
   resources "/cardsets", Api.CardsetController
  end
end
