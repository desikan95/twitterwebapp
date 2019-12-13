defmodule TwitterwebappWeb.Router do
  use TwitterwebappWeb, :router

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

  scope "/", TwitterwebappWeb do
    pipe_through :browser

    get "/", PageController, :index
<<<<<<< HEAD
    get "/simulate",UserController,:simulate
    resources "/users", UserController

=======
    resources "/users", UserController
>>>>>>> c07228210e5d41815113fae53807001c8c8171c0
  end

  # Other scopes may use custom stacks.
  # scope "/api", TwitterwebappWeb do
  #   pipe_through :api
  # end
end
