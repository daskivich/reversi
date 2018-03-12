defmodule ReversiWeb.GameController do
  use ReversiWeb, :controller

  alias Reversi.Play
  alias Reversi.Play.Game

  def index(conn, params) do
    games = Play.list_games("yours_complete_two_player", params["user_id"])
    render(conn, "index.html", games: games)
  end

  def new(conn, _params) do
    changeset = Play.change_game(%Game{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"game" => game_params}) do
    case Play.create_game(game_params) do
      {:ok, game} ->
        conn
        |> put_flash(:info, "Game created successfully.")
        |> redirect(to: page_path(conn, :home))
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

  def update(conn, %{"id" => id, "game" => game_params}) do
    IO.puts "entered game_controller/update"
    game = Play.get_game!(id)

    case Play.update_game(game, game_params) do
      {:ok, game} ->
        conn
        |> put_flash(:info, "Game updated successfully.")
        |> redirect(to: page_path(conn, :game, game))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", game: game, changeset: changeset)
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
