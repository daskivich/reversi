defmodule ReversiWeb.PageController do
  use ReversiWeb, :controller

  alias Reversi.Play
  alias Reversi.Play.Game

  def index(conn, _params) do
    render conn, "index.html"
  end

  # if a user is logged in, render the home page
  # otherwise redirect to the log-in page (see index above)
  def home(conn, params) do
    user_id = get_session(conn, :user_id)
    games = Play.list_games(params["which"], user_id)

    if user_id do
      changeset = Play.change_game(%Game{})
      render conn, "home.html", changeset: changeset, games: games
    else
      conn
      |> redirect(to: page_path(conn, :index))
    end
  end

  def game(conn, params) do
    user_id = get_session(conn, :user_id)

    if user_id do
      render conn, "game.html", game: params["game"]
    else
      conn
      |> redirect(to: page_path(conn, :index))
    end
  end
end
