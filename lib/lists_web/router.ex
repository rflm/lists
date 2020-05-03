defmodule ListsWeb.Router do
  use ListsWeb, :router

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

  scope "/", ListsWeb do
    pipe_through :browser

    get "/", ItemController, :index
    resources "/items", ItemController, only: [:index]
  end

  # Other scopes may use custom stacks.
  scope "/api", ListsWeb do
    pipe_through :api

    resources "/items", ItemController, only: [:create, :show, :delete] do
      post "/check", ItemController, :check, as: :check
      post "/uncheck", ItemController, :uncheck, as: :uncheck
    end
  end
end
