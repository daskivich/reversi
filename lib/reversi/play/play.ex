defmodule Reversi.Play do
  @moduledoc """
  The Play context.
  """

  import Ecto.Query, warn: false
  alias Reversi.Repo

  alias Reversi.Play.Game
  alias Reversi.Play.State

  # returns the client view of the given game
  def client_view(game_id) do
    IO.puts("entered Play.client_view()")

    g = get_game(game_id)
    s = get_current_state(game_id)
    p1 = g.player_one
    p2 = g.player_two

    # if p2.color_primary == p1.color_primary do
    #   color_two = p2.color_secondary
    # else
    #   color_two = p2.color_primary
    # end

    vals = get_vals(s)

    %{
      vals: vals,
      name_one: p1.name,
      color_one: "info",#p1.color_primary,
      score_one: get_score(vals, 1),
      name_two: p2.name,
      color_two: "warning",#color_two,
      score_two: get_score(vals, 2),
      player_ones_turn: s.player_ones_turn,
      is_over: g.is_over
    }
  end

  def get_score(vals, player) do
    vals
    |> Enum.reduce(0, fn(v, acc) -> if v == player, do: acc + 1, else: acc end)
  end

  #
  def select(game, index, current_user_id) do
    current_state = get_current_state(game.id)
    player = if current_state.player_ones_turn, do: 1, else: 2
    current_user_id = String.to_integer(current_user_id)

    IO.write("game over: ")
    IO.puts(game.is_over)
    IO.write("selected value: ")
    IO.puts(get_val(current_state, index))
    IO.write("current player: ")
    IO.puts(if current_state.player_ones_turn, do: game.player_one.id, else: game.player_two.id)
    IO.write("current user: ")
    IO.puts(current_user_id)
    IO.write("is current user's turn: ")
    IO.puts(is_current_users_turn(game, current_state, current_user_id))

    if !game.is_over && get_val(current_state, index) == 0 && is_current_users_turn(game, current_state, current_user_id) do
      indexes_to_flip = get_indexes_to_flip(index, player, current_state)

      IO.write("indexes to flip: ")
      IO.puts(Enum.count(indexes_to_flip))

      if Enum.count(indexes_to_flip) < 1 do
        game
      else
        # create new state from attrs
        attrs = get_new_state_attrs(current_state, indexes_to_flip, index, player)
        create_state(attrs)
        current_state = get_current_state(game.id)

        cond do
          has_next_move(get_opponent(player), current_state) -> :ok
          has_next_move(player, current_state) -> update_state(current_state, %{player_ones_turn: (if player == 1, do: true, else: false)})
          true -> update_game(game, %{is_over: true})
        end

        game
      end
    else
      game
    end
  end

  def has_next_move(player, current_state) do
    # get indexes of all 0's in current_state
    # concatenate list of indexes to flip for each 0
    # if list is not empty, return true, else return false
    flippable_indexes = get_zero_indexes(current_state)
    |> Enum.flat_map(fn(i) -> get_indexes_to_flip(i, player, current_state) end)

    Enum.count(flippable_indexes) > 0
  end

  def get_zero_indexes(current_state) do
    index_string_list()
    |> Enum.filter(fn(i) -> get_val(current_state, i) == 0 end)
  end

  def get_new_state_attrs(current_state, indexes_to_flip, selected, player) do
    attrs = get_current_state_attrs(current_state)

    Enum.each(indexes_to_flip, fn(i) -> Map.put(attrs, String.to_atom(i), player) end)

    attrs
    |> Map.put(String.to_atom(selected), player)
    |> Map.put(:plater_ones_turn, !current_state.player_ones_turn)
    |> Map.put(:game_id, current_state.game_id)
  end

  def is_current_users_turn(game, current_state, current_user_id) do
    (current_state.player_ones_turn && game.player_one.id == current_user_id) || (!current_state.player_ones_turn && game.player_two.id == current_user_id)
  end

  def index_string_list() do
    ["r1c1", "r1c2", "r1c3", "r1c4", "r1c5", "r1c6", "r1c7", "r1c8",
      "r2c1", "r2c2", "r2c3", "r2c4", "r2c5", "r2c6", "r2c7", "r2c8",
      "r3c1", "r3c2", "r3c3", "r3c4", "r3c5", "r3c6", "r3c7", "r3c8",
      "r4c1", "r4c2", "r4c3", "r4c4", "r4c5", "r4c6", "r4c7", "r4c8",
      "r5c1", "r5c2", "r5c3", "r5c4", "r5c5", "r5c6", "r5c7", "r5c8",
      "r6c1", "r6c2", "r6c3", "r6c4", "r6c5", "r6c6", "r6c7", "r6c8",
      "r7c1", "r7c2", "r7c3", "r7c4", "r7c5", "r7c6", "r7c7", "r7c8",
      "r8c1", "r8c2", "r8c3", "r8c4", "r8c5", "r8c6", "r8c7", "r8c8"]
  end

  def get_current_state_attrs(current_state) do
    %{
      r1c1: get_val(current_state, "r1c1"),
      r1c2: get_val(current_state, "r1c2"),
      r1c3: get_val(current_state, "r1c3"),
      r1c4: get_val(current_state, "r1c4"),
      r1c5: get_val(current_state, "r1c5"),
      r1c6: get_val(current_state, "r1c6"),
      r1c7: get_val(current_state, "r1c7"),
      r1c8: get_val(current_state, "r1c8"),
      r2c1: get_val(current_state, "r2c1"),
      r2c2: get_val(current_state, "r2c2"),
      r2c3: get_val(current_state, "r2c3"),
      r2c4: get_val(current_state, "r2c4"),
      r2c5: get_val(current_state, "r2c5"),
      r2c6: get_val(current_state, "r2c6"),
      r2c7: get_val(current_state, "r2c7"),
      r2c8: get_val(current_state, "r2c8"),
      r3c1: get_val(current_state, "r3c1"),
      r3c2: get_val(current_state, "r3c2"),
      r3c3: get_val(current_state, "r3c3"),
      r3c4: get_val(current_state, "r3c4"),
      r3c5: get_val(current_state, "r3c5"),
      r3c6: get_val(current_state, "r3c6"),
      r3c7: get_val(current_state, "r3c7"),
      r3c8: get_val(current_state, "r3c8"),
      r4c1: get_val(current_state, "r4c1"),
      r4c2: get_val(current_state, "r4c2"),
      r4c3: get_val(current_state, "r4c3"),
      r4c4: get_val(current_state, "r4c4"),
      r4c5: get_val(current_state, "r4c5"),
      r4c6: get_val(current_state, "r4c6"),
      r4c7: get_val(current_state, "r4c7"),
      r4c8: get_val(current_state, "r4c8"),
      r5c1: get_val(current_state, "r5c1"),
      r5c2: get_val(current_state, "r5c2"),
      r5c3: get_val(current_state, "r5c3"),
      r5c4: get_val(current_state, "r5c4"),
      r5c5: get_val(current_state, "r5c5"),
      r5c6: get_val(current_state, "r5c6"),
      r5c7: get_val(current_state, "r5c7"),
      r5c8: get_val(current_state, "r5c8"),
      r6c1: get_val(current_state, "r6c1"),
      r6c2: get_val(current_state, "r6c2"),
      r6c3: get_val(current_state, "r6c3"),
      r6c4: get_val(current_state, "r6c4"),
      r6c5: get_val(current_state, "r6c5"),
      r6c6: get_val(current_state, "r6c6"),
      r6c7: get_val(current_state, "r6c7"),
      r6c8: get_val(current_state, "r6c8"),
      r7c1: get_val(current_state, "r7c1"),
      r7c2: get_val(current_state, "r7c2"),
      r7c3: get_val(current_state, "r7c3"),
      r7c4: get_val(current_state, "r7c4"),
      r7c5: get_val(current_state, "r7c5"),
      r7c6: get_val(current_state, "r7c6"),
      r7c7: get_val(current_state, "r7c7"),
      r7c8: get_val(current_state, "r7c8"),
      r8c1: get_val(current_state, "r8c1"),
      r8c2: get_val(current_state, "r8c2"),
      r8c3: get_val(current_state, "r8c3"),
      r8c4: get_val(current_state, "r8c4"),
      r8c5: get_val(current_state, "r8c5"),
      r8c6: get_val(current_state, "r8c6"),
      r8c7: get_val(current_state, "r8c7"),
      r8c8: get_val(current_state, "r8c8"),
    }
  end

  def get_indexes_to_flip(index, player, current_state) do
    { row, col } = get_row_col_indexes(index)
    opponent = get_opponent(player)

    IO.write("selected row: ")
    IO.puts(row)
    IO.write("selected col: ")
    IO.puts(col)
    IO.write("current player: ")
    IO.puts(player)
    IO.write("current opponent: ")
    IO.puts(opponent)

    []
    |> Enum.concat(get_east_to_flip(player, opponent, row, col, current_state))
    |> Enum.concat(get_south_to_flip(player, opponent, row, col, current_state))
    |> Enum.concat(get_west_to_flip(player, opponent, row, col, current_state))
    |> Enum.concat(get_north_to_flip(player, opponent, row, col, current_state))
  end

  # gets a list of indexes to flip to the east of the selected row/col
  def get_east_to_flip(player, opponent, row, col, current_state) do
    if col == 6 || col == 7 do
      []
    else
      east = (col + 1)..7
      |> Enum.map(fn(c) -> get_index(row, c) end)
      |> valid_move(player, opponent, current_state)

      IO.write("east: [")
      Enum.each(east, fn(i) -> IO.write(i) end)
      IO.puts("]")

      east
    end
  end

  # gets a list of indexes to flip to the south of the selected row/col
  def get_south_to_flip(player, opponent, row, col, current_state) do
    if row == 6 || row == 7 do
      []
    else
      south = (row + 1)..7
      |> Enum.map(fn(r) -> get_index(r, col) end)
      |> valid_move(player, opponent, current_state)

      IO.write("south: [")
      Enum.each(south, fn(i) -> IO.write(i) end)
      IO.puts("]")

      south
    end
  end

  # gets a list of indexes to flip to the west of the selected row/col
  def get_west_to_flip(player, opponent, row, col, current_state) do
    if col == 0 || col == 1 do
      []
    else
      west = 0..(col - 1)
      |> Enum.map(fn(c) -> get_index(row, c) end)
      |> Enum.reverse()
      |> valid_move(player, opponent, current_state)

      IO.write("west: [")
      Enum.each(west, fn(i) -> IO.write(i) end)
      IO.puts("]")

      west
    end
  end

  # gets a list of indexes to flip to the north of the selected row/col
  def get_north_to_flip(player, opponent, row, col, current_state) do
    if row == 0 || row == 1 do
      []
    else
      north = 0..(row - 1)
      |> Enum.map(fn(r) -> get_index(r, col) end)
      |> Enum.reverse()
      |> valid_move(player, opponent, current_state)

      IO.write("north: [")
      Enum.each(north, fn(i) -> IO.write(i) end)
      IO.puts("]")

      north
    end
  end

  def valid_move([first | rest], player, opponent, current_state) do
    IO.puts("entering valid_move()")
    IO.write("first: ")
    IO.puts(first)

    if get_val(current_state, first) != opponent do
      []
    else
      valid_rest(player, opponent, rest, [first], current_state)
    end
  end

  def valid_rest(player, opponent, rest, possible_flips, current_state) do
    IO.puts("entering valid_move()")

    if rest == [] do
      IO.puts("rest: []")
      []
    else
      [head | tail] = rest

      IO.write("head: ")
      IO.puts(head)

      val = get_val(current_state, head)

      IO.write("val: ")
      IO.puts(val)

      cond do
        val == 0 -> []
        val == player -> possible_flips
        val == opponent -> valid_rest(player, opponent, tail, Enum.concat(possible_flips, [head]), current_state)
      end
    end
  end

  def get_opponent(player) do
    case player do
      1 -> 2
      2 -> 1
      _ -> 0
    end
  end

  # returns the list-based index of the given zero-based row/col indexes
  def get_vals_index(row, col) do
    (row * 8) + col
  end

  # returns the db field/react Tile index from the given zero-based row/col indexes
  def get_index(row, col) do
    "r" <> Integer.to_string(row + 1) <> "c" <> Integer.to_string(col + 1)
  end

  def get_row_col_indexes(index) do
    { String.to_integer(String.at(index, 1)) - 1, String.to_integer(String.at(index, 3)) - 1 }
  end

  def get_val(current_state, index) do
    case index do
      "r1c1" -> current_state.r1c1
      "r1c2" -> current_state.r1c2
      "r1c3" -> current_state.r1c3
      "r1c4" -> current_state.r1c4
      "r1c5" -> current_state.r1c5
      "r1c6" -> current_state.r1c6
      "r1c7" -> current_state.r1c7
      "r1c8" -> current_state.r1c8
      "r2c1" -> current_state.r2c1
      "r2c2" -> current_state.r2c2
      "r2c3" -> current_state.r2c3
      "r2c4" -> current_state.r2c4
      "r2c5" -> current_state.r2c5
      "r2c6" -> current_state.r2c6
      "r2c7" -> current_state.r2c7
      "r2c8" -> current_state.r2c8
      "r3c1" -> current_state.r3c1
      "r3c2" -> current_state.r3c2
      "r3c3" -> current_state.r3c3
      "r3c4" -> current_state.r3c4
      "r3c5" -> current_state.r3c5
      "r3c6" -> current_state.r3c6
      "r3c7" -> current_state.r3c7
      "r3c8" -> current_state.r3c8
      "r4c1" -> current_state.r4c1
      "r4c2" -> current_state.r4c2
      "r4c3" -> current_state.r4c3
      "r4c4" -> current_state.r4c4
      "r4c5" -> current_state.r4c5
      "r4c6" -> current_state.r4c6
      "r4c7" -> current_state.r4c7
      "r4c8" -> current_state.r4c8
      "r5c1" -> current_state.r5c1
      "r5c2" -> current_state.r5c2
      "r5c3" -> current_state.r5c3
      "r5c4" -> current_state.r5c4
      "r5c5" -> current_state.r5c5
      "r5c6" -> current_state.r5c6
      "r5c7" -> current_state.r5c7
      "r5c8" -> current_state.r5c8
      "r6c1" -> current_state.r6c1
      "r6c2" -> current_state.r6c2
      "r6c3" -> current_state.r6c3
      "r6c4" -> current_state.r6c4
      "r6c5" -> current_state.r6c5
      "r6c6" -> current_state.r6c6
      "r6c7" -> current_state.r6c7
      "r6c8" -> current_state.r6c8
      "r7c1" -> current_state.r7c1
      "r7c2" -> current_state.r7c2
      "r7c3" -> current_state.r7c3
      "r7c4" -> current_state.r7c4
      "r7c5" -> current_state.r7c5
      "r7c6" -> current_state.r7c6
      "r7c7" -> current_state.r7c7
      "r7c8" -> current_state.r7c8
      "r8c1" -> current_state.r8c1
      "r8c2" -> current_state.r8c2
      "r8c3" -> current_state.r8c3
      "r8c4" -> current_state.r8c4
      "r8c5" -> current_state.r8c5
      "r8c6" -> current_state.r8c6
      "r8c7" -> current_state.r8c7
      "r8c8" -> current_state.r8c8
    end
  end

  def get_vals(state) do
    s = state
    [s.r1c1, s.r1c2, s.r1c3, s.r1c4, s.r1c5, s.r1c6, s.r1c7, s.r1c8,
      s.r2c1, s.r2c2, s.r2c3, s.r2c4, s.r2c5, s.r2c6, s.r2c7, s.r2c8,
      s.r3c1, s.r3c2, s.r3c3, s.r3c4, s.r3c5, s.r3c6, s.r3c7, s.r3c8,
      s.r4c1, s.r4c2, s.r4c3, s.r4c4, s.r4c5, s.r4c6, s.r4c7, s.r4c8,
      s.r5c1, s.r5c2, s.r5c3, s.r5c4, s.r5c5, s.r5c6, s.r5c7, s.r5c8,
      s.r6c1, s.r6c2, s.r6c3, s.r6c4, s.r6c5, s.r6c6, s.r6c7, s.r6c8,
      s.r7c1, s.r7c2, s.r7c3, s.r7c4, s.r7c5, s.r7c6, s.r7c7, s.r7c8,
      s.r8c1, s.r8c2, s.r8c3, s.r8c4, s.r8c5, s.r8c6, s.r8c7, s.r8c8]
  end

  # takes a game id and returns the current state of this game
  def get_current_state(game_id) do
    query = from s in State,
      where: s.game_id == ^game_id,
      select: s
    query = from q in query,
      order_by: q.inserted_at
    Ecto.Query.last(query)
    |> Repo.one()
  end

  @doc """
  Returns the list of games.

  ## Examples

      iex> list_games()
      [%Game{}, ...]

  """
  def list_games do
    Repo.all(Game)
    |> Repo.preload(:player_one)
    |> Repo.preload(:player_two)
  end

  @doc """
  Gets a single game.

  Raises `Ecto.NoResultsError` if the Game does not exist.

  ## Examples

      iex> get_game!(123)
      %Game{}

      iex> get_game!(456)
      ** (Ecto.NoResultsError)

  """
  def get_game!(id), do: Repo.get!(Game, id)

  # a non-bang version of get game that doesn't throw an error
  def get_game(id) do
    Repo.get(Game, id)
    |> Repo.preload(:player_one)
    |> Repo.preload(:player_two)
  end

  @doc """
  Creates a game.

  ## Examples

      iex> create_game(%{field: value})
      {:ok, %Game{}}

      iex> create_game(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_game(attrs \\ %{}) do
    # prepare new game to be inserted into db
    game = %Game{} |> Game.changeset(attrs)

    # insert new game into db and get response with new game
    { resp, game } = Repo.insert(game)

    # create new starting state
    newState = %{ :game_id => game.id, :r4c4 => 2, :r4c5 => 1, :r5c4 => 1, :r5c5 => 2 }
    create_state(newState)

    # return response with game
    { resp, game }
  end

  @doc """
  Updates a game.

  ## Examples

      iex> update_game(game, %{field: new_value})
      {:ok, %Game{}}

      iex> update_game(game, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_game(%Game{} = game, attrs) do
    game
    |> Game.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Game.

  ## Examples

      iex> delete_game(game)
      {:ok, %Game{}}

      iex> delete_game(game)
      {:error, %Ecto.Changeset{}}

  """
  def delete_game(%Game{} = game) do
    Repo.delete(game)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking game changes.

  ## Examples

      iex> change_game(game)
      %Ecto.Changeset{source: %Game{}}

  """
  def change_game(%Game{} = game) do
    Game.changeset(game, %{})
  end

  alias Reversi.Play.State

  @doc """
  Returns the list of states.

  ## Examples

      iex> list_states()
      [%State{}, ...]

  """
  def list_states do
    Repo.all(State)
  end

  @doc """
  Gets a single state.

  Raises `Ecto.NoResultsError` if the State does not exist.

  ## Examples

      iex> get_state!(123)
      %State{}

      iex> get_state!(456)
      ** (Ecto.NoResultsError)

  """
  def get_state!(id), do: Repo.get!(State, id)

  @doc """
  Creates a state.

  ## Examples

      iex> create_state(%{field: value})
      {:ok, %State{}}

      iex> create_state(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_state(attrs \\ %{}) do
    %State{}
    |> State.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a state.

  ## Examples

      iex> update_state(state, %{field: new_value})
      {:ok, %State{}}

      iex> update_state(state, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_state(%State{} = state, attrs) do
    state
    |> State.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a State.

  ## Examples

      iex> delete_state(state)
      {:ok, %State{}}

      iex> delete_state(state)
      {:error, %Ecto.Changeset{}}

  """
  def delete_state(%State{} = state) do
    Repo.delete(state)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking state changes.

  ## Examples

      iex> change_state(state)
      %Ecto.Changeset{source: %State{}}

  """
  def change_state(%State{} = state) do
    State.changeset(state, %{})
  end
end
