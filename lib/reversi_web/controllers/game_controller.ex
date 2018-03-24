defmodule ReversiWeb.GameController do
  use ReversiWeb, :controller

  alias Reversi.Play
  alias Reversi.Play.Game

  # used via a leader board "games" button click to list the completed games
  # of the user specified in the params
  def index(conn, params) do
    games = Play.list_games("yours_complete_two_player", params["user_id"])
    render(conn, "index.html", games: games)
  end

  def new(conn, _params) do
    changeset = Play.change_game(%Game{})
    render(conn, "new.html", changeset: changeset)
  end

  # creates an initial back-end game state as well, within Play.create_game()
  def create(conn, %{"game" => game_params}) do
    case Play.create_game(game_params) do
      {:ok, _game} ->
        conn
        |> put_flash(:info, "Game created successfully.")
        |> redirect(to: page_path(conn, :home, which: "all_to_join"))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    game = Play.get_game!(id)
    render(conn, "show.html", game: game)
  end

  def edit(conn, %{"id" => id}) do
    game = Play.get_game!(id)
    changeset = Play.change_game(game)
    render(conn, "edit.html", game: game, changeset: changeset)
  end

  # the only time a game is updated is when a second player joins
  def update(conn, %{"id" => id, "game" => game_params}) do
    game = Play.get_game!(id)

    if game.player_two_id && game_params["player_two_id"] do
      conn
      |> put_flash(:error, "Sorry, but a second player has recently joined this game.")
      |> redirect(to: page_path(conn, :home, which: "all_to_join"))
    else
      case Play.update_game(game, game_params) do
        {:ok, game} ->
          conn
          |> put_flash(:info, "Game updated successfully.")
          |> redirect(to: page_path(conn, :game, game))
        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", game: game, changeset: changeset)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    game = Play.get_game!(id)
    {:ok, _game} = Play.delete_game(game)

    conn
    |> put_flash(:info, "Game deleted successfully.")
    |> redirect(to: game_path(conn, :index))
  end
end
