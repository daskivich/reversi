defmodule Reversi.PlayTest do
  use Reversi.DataCase

  alias Reversi.Play

  describe "games" do
    alias Reversi.Play.Game

    @valid_attrs %{is_over: true}
    @update_attrs %{is_over: false}
    @invalid_attrs %{is_over: nil}

    def game_fixture(attrs \\ %{}) do
      {:ok, game} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Play.create_game()

      game
    end

    test "list_games/0 returns all games" do
      game = game_fixture()
      assert Play.list_games() == [game]
    end

    test "get_game!/1 returns the game with given id" do
      game = game_fixture()
      assert Play.get_game!(game.id) == game
    end

    test "create_game/1 with valid data creates a game" do
      assert {:ok, %Game{} = game} = Play.create_game(@valid_attrs)
      assert game.is_over == true
    end

    test "create_game/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Play.create_game(@invalid_attrs)
    end

    test "update_game/2 with valid data updates the game" do
      game = game_fixture()
      assert {:ok, game} = Play.update_game(game, @update_attrs)
      assert %Game{} = game
      assert game.is_over == false
    end

    test "update_game/2 with invalid data returns error changeset" do
      game = game_fixture()
      assert {:error, %Ecto.Changeset{}} = Play.update_game(game, @invalid_attrs)
      assert game == Play.get_game!(game.id)
    end

    test "delete_game/1 deletes the game" do
      game = game_fixture()
      assert {:ok, %Game{}} = Play.delete_game(game)
      assert_raise Ecto.NoResultsError, fn -> Play.get_game!(game.id) end
    end

    test "change_game/1 returns a game changeset" do
      game = game_fixture()
      assert %Ecto.Changeset{} = Play.change_game(game)
    end
  end
end
