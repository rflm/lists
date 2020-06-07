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
    get "/", ListController, :index
    resources "/lists", ListController, only: [:index, :show]
    resources "/registrations", UserController, only: [:create, :new]
  end

  # Other scopes may use custom stacks.
  scope "/api", ListsWeb do
    pipe_through :api

    resources "/lists", ListController, only: [:create, :show, :delete] do
      resources "/items", ItemController, only: [:create, :show, :delete] do
        post "/check", ItemController, :check, as: :check
        post "/uncheck", ItemController, :uncheck, as: :uncheck
      end
    end
  end
end
