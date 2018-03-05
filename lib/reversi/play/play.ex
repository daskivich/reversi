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
    g = get_game(game_id)
    s = get_current_state(game_id)
    p1 = g.player_one
    p2 = g.player_two

    if p2.icon_primary == p1.icon_primary do
      icon_two = p2.icon_secondary
    else
      icon_two = p2.icon_primary
    end

    if p2.color_primary == p1.color_primary do
      color_two = p2.color_secondary
    else
      color_two = p2.color_primary
    end

    vals = [s.r1c1, s.r1c2, s.r1c3, s.r1c4, s.r1c5, s.r1c6, s.r1c7, s.r1c8,
      s.r2c1, s.r2c2, s.r2c3, s.r2c4, s.r2c5, s.r2c6, s.r2c7, s.r2c8,
      s.r3c1, s.r3c2, s.r3c3, s.r3c4, s.r3c5, s.r3c6, s.r3c7, s.r3c8,
      s.r4c1, s.r4c2, s.r4c3, s.r4c4, s.r4c5, s.r4c6, s.r4c7, s.r4c8,
      s.r5c1, s.r5c2, s.r5c3, s.r5c4, s.r5c5, s.r5c6, s.r5c7, s.r5c8,
      s.r6c1, s.r6c2, s.r6c3, s.r6c4, s.r6c5, s.r6c6, s.r6c7, s.r6c8,
      s.r7c1, s.r7c2, s.r7c3, s.r7c4, s.r7c5, s.r7c6, s.r7c7, s.r7c8,
      s.r8c1, s.r8c2, s.r8c3, s.r8c4, s.r8c5, s.r8c6, s.r8c7, s.r8c8]

    %{
      vals: vals,
      player_one: p1.id,
      icon_one: p1.icon_primary,
      color_one: p1.color_primary,
      score_one: get_score(vals, 1),
      player_two: p2.id,
      icon_two: icon_two,
      color_two: color_two,
      score_two: get_score(vals, 2),
      player_ones_turn: s.player_ones_turn,
      is_over: g.is_over
    }
  end

  def get_score(vals, player) do
    vals
    |> Enum.reduce(0, fn(v, acc) -> if v == player do acc + 1 end end)
  end

  #
  def select(game, index) do

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
    %Game{}
    |> Game.changeset(attrs)
    |> Repo.insert()
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
