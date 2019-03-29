defmodule VocialWeb.Router do
  use VocialWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug VocialWeb.VerifyApiKey
  end

  scope "/", VocialWeb do
    pipe_through :browser

    get "/", PageController, :index

    resources "/polls", PollController, only: [:index, :new, :create, :show]
    #get "/polls", PollController, :index
    #get "/polls/new", PollController, :new
    #post "/polls", PollController, :create

    resources "/users", UserController, only: [:new, :show, :create]
    #get "/users/new", UserController, :new
    #get "/users/:id", UserController, :show
    #post "/users", UserController, :create

    resources "/sessions", SessionController, only: [:create]

    get "/login", SessionController, :new
    get "/logout", SessionController, :delete

    get "/options/:id/vote", PollController, :vote

    get "/history", PageController, :history

    post "/users/:id/generate_api_key", UserController, :generate_api_key
  end

  # Other scopes may use custom stacks.
  scope "/api", VocialWeb do
    pipe_through :api

    resources "/polls", Api.PollController, only: [:index, :show]
  end
end
