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

  describe "states" do
    alias Reversi.Play.State

    @valid_attrs %{r2c6: 42, r5c3: 42, r2c8: 42, r3c6: 42, r4c1: 42, r5c4: 42, r1c5: 42, r8c4: 42, r4c5: 42, r6c8: 42, r1c6: 42, r8c1: 42, r4c3: 42, r8c7: 42, r2c7: 42, r5c8: 42, r7c7: 42, r2c5: 42, r8c3: 42, r8c5: 42, r8c6: 42, r1c8: 42, r4c6: 42, r7c5: 42, r6c2: 42, r8c8: 42, r7c6: 42, r2c3: 42, r6c1: 42, r2c1: 42, r7c3: 42, r3c5: 42, r4c7: 42, r2c4: 42, r4c8: 42, r3c1: 42, r1c7: 42, r7c8: 42, r6c6: 42, r7c4: 42, r6c3: 42, r3c7: 42, r6c4: 42, r4c2: 42, r1c2: 42, r5c1: 42, r8c2: 42, r6c7: 42, r7c1: 42, player_ones_turn: true, ...}
    @update_attrs %{r2c6: 43, r5c3: 43, r2c8: 43, r3c6: 43, r4c1: 43, r5c4: 43, r1c5: 43, r8c4: 43, r4c5: 43, r6c8: 43, r1c6: 43, r8c1: 43, r4c3: 43, r8c7: 43, r2c7: 43, r5c8: 43, r7c7: 43, r2c5: 43, r8c3: 43, r8c5: 43, r8c6: 43, r1c8: 43, r4c6: 43, r7c5: 43, r6c2: 43, r8c8: 43, r7c6: 43, r2c3: 43, r6c1: 43, r2c1: 43, r7c3: 43, r3c5: 43, r4c7: 43, r2c4: 43, r4c8: 43, r3c1: 43, r1c7: 43, r7c8: 43, r6c6: 43, r7c4: 43, r6c3: 43, r3c7: 43, r6c4: 43, r4c2: 43, r1c2: 43, r5c1: 43, r8c2: 43, r6c7: 43, r7c1: 43, player_ones_turn: false, ...}
    @invalid_attrs %{r2c6: nil, r5c3: nil, r2c8: nil, r3c6: nil, r4c1: nil, r5c4: nil, r1c5: nil, r8c4: nil, r4c5: nil, r6c8: nil, r1c6: nil, r8c1: nil, r4c3: nil, r8c7: nil, r2c7: nil, r5c8: nil, r7c7: nil, r2c5: nil, r8c3: nil, r8c5: nil, r8c6: nil, r1c8: nil, r4c6: nil, r7c5: nil, r6c2: nil, r8c8: nil, r7c6: nil, r2c3: nil, r6c1: nil, r2c1: nil, r7c3: nil, r3c5: nil, r4c7: nil, r2c4: nil, r4c8: nil, r3c1: nil, r1c7: nil, r7c8: nil, r6c6: nil, r7c4: nil, r6c3: nil, r3c7: nil, r6c4: nil, r4c2: nil, r1c2: nil, r5c1: nil, r8c2: nil, r6c7: nil, r7c1: nil, player_ones_turn: nil, ...}

    def state_fixture(attrs \\ %{}) do
      {:ok, state} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Play.create_state()

      state
    end

    test "list_states/0 returns all states" do
      state = state_fixture()
      assert Play.list_states() == [state]
    end

    test "get_state!/1 returns the state with given id" do
      state = state_fixture()
      assert Play.get_state!(state.id) == state
    end

    test "create_state/1 with valid data creates a state" do
      assert {:ok, %State{} = state} = Play.create_state(@valid_attrs)
      assert state.r2c6 == 42
      assert state.r5c3 == 42
      assert state.r2c8 == 42
      assert state.r3c6 == 42
      assert state.r4c1 == 42
      assert state.r5c4 == 42
      assert state.r1c5 == 42
      assert state.r8c4 == 42
      assert state.r4c5 == 42
      assert state.r6c8 == 42
      assert state.r1c6 == 42
      assert state.r8c1 == 42
      assert state.r4c3 == 42
      assert state.r8c7 == 42
      assert state.r2c7 == 42
      assert state.r5c8 == 42
      assert state.r7c7 == 42
      assert state.r2c5 == 42
      assert state.r8c3 == 42
      assert state.r8c5 == 42
      assert state.r8c6 == 42
      assert state.r1c8 == 42
      assert state.r4c6 == 42
      assert state.r7c5 == 42
      assert state.r6c2 == 42
      assert state.r8c8 == 42
      assert state.r7c6 == 42
      assert state.r2c3 == 42
      assert state.r6c1 == 42
      assert state.r2c1 == 42
      assert state.r7c3 == 42
      assert state.r3c5 == 42
      assert state.r4c7 == 42
      assert state.r2c4 == 42
      assert state.r4c8 == 42
      assert state.r3c1 == 42
      assert state.r1c7 == 42
      assert state.r7c8 == 42
      assert state.r6c6 == 42
      assert state.r7c4 == 42
      assert state.r6c3 == 42
      assert state.r3c7 == 42
      assert state.r6c4 == 42
      assert state.r4c2 == 42
      assert state.r1c2 == 42
      assert state.r5c1 == 42
      assert state.r8c2 == 42
      assert state.r6c7 == 42
      assert state.r7c1 == 42
      assert state.player_ones_turn == true
      assert state.r3c4 == 42
      assert state.r5c7 == 42
      assert state.r5c6 == 42
      assert state.r3c8 == 42
      assert state.r2c2 == 42
      assert state.r5c5 == 42
      assert state.r4c4 == 42
      assert state.r5c2 == 42
      assert state.r7c2 == 42
      assert state.r1c3 == 42
      assert state.r1c1 == 42
      assert state.r1c4 == 42
      assert state.r3c3 == 42
      assert state.r3c2 == 42
      assert state.r6c5 == 42
    end

    test "create_state/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Play.create_state(@invalid_attrs)
    end

    test "update_state/2 with valid data updates the state" do
      state = state_fixture()
      assert {:ok, state} = Play.update_state(state, @update_attrs)
      assert %State{} = state
      assert state.r2c6 == 43
      assert state.r5c3 == 43
      assert state.r2c8 == 43
      assert state.r3c6 == 43
      assert state.r4c1 == 43
      assert state.r5c4 == 43
      assert state.r1c5 == 43
      assert state.r8c4 == 43
      assert state.r4c5 == 43
      assert state.r6c8 == 43
      assert state.r1c6 == 43
      assert state.r8c1 == 43
      assert state.r4c3 == 43
      assert state.r8c7 == 43
      assert state.r2c7 == 43
      assert state.r5c8 == 43
      assert state.r7c7 == 43
      assert state.r2c5 == 43
      assert state.r8c3 == 43
      assert state.r8c5 == 43
      assert state.r8c6 == 43
      assert state.r1c8 == 43
      assert state.r4c6 == 43
      assert state.r7c5 == 43
      assert state.r6c2 == 43
      assert state.r8c8 == 43
      assert state.r7c6 == 43
      assert state.r2c3 == 43
      assert state.r6c1 == 43
      assert state.r2c1 == 43
      assert state.r7c3 == 43
      assert state.r3c5 == 43
      assert state.r4c7 == 43
      assert state.r2c4 == 43
      assert state.r4c8 == 43
      assert state.r3c1 == 43
      assert state.r1c7 == 43
      assert state.r7c8 == 43
      assert state.r6c6 == 43
      assert state.r7c4 == 43
      assert state.r6c3 == 43
      assert state.r3c7 == 43
      assert state.r6c4 == 43
      assert state.r4c2 == 43
      assert state.r1c2 == 43
      assert state.r5c1 == 43
      assert state.r8c2 == 43
      assert state.r6c7 == 43
      assert state.r7c1 == 43
      assert state.player_ones_turn == false
      assert state.r3c4 == 43
      assert state.r5c7 == 43
      assert state.r5c6 == 43
      assert state.r3c8 == 43
      assert state.r2c2 == 43
      assert state.r5c5 == 43
      assert state.r4c4 == 43
      assert state.r5c2 == 43
      assert state.r7c2 == 43
      assert state.r1c3 == 43
      assert state.r1c1 == 43
      assert state.r1c4 == 43
      assert state.r3c3 == 43
      assert state.r3c2 == 43
      assert state.r6c5 == 43
    end

    test "update_state/2 with invalid data returns error changeset" do
      state = state_fixture()
      assert {:error, %Ecto.Changeset{}} = Play.update_state(state, @invalid_attrs)
      assert state == Play.get_state!(state.id)
    end

    test "delete_state/1 deletes the state" do
      state = state_fixture()
      assert {:ok, %State{}} = Play.delete_state(state)
      assert_raise Ecto.NoResultsError, fn -> Play.get_state!(state.id) end
    end

    test "change_state/1 returns a state changeset" do
      state = state_fixture()
      assert %Ecto.Changeset{} = Play.change_state(state)
    end
  end
end
