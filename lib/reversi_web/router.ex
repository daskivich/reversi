defmodule ReversiWeb.Router do
  use ReversiWeb, :router

  alias Reversi.Accounts

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :get_current_user
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  # a method that sets the current_user
  def get_current_user(conn, _params) do
    user_id = get_session(conn, :user_id)

    if user_id do
      user = Accounts.get_user!(user_id)
      assign(conn, :current_user, user)
    else
      assign(conn, :current_user, nil)
    end
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ReversiWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/home", PageController, :home
    get "/game/:game", PageController, :game
    resources "/users", UserController
    post "/session", SessionController, :create
    delete "/session", SessionController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", ReversiWeb do
  #   pipe_through :api
  # end
end
