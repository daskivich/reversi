defmodule Reversi.Play.Game do
  use Ecto.Schema
  import Ecto.Changeset

  alias Reversi.Accounts.User
  alias Reversi.Play.State

  schema "games" do
    field :is_over, :boolean, default: false # true of game is over, false otherwise
    belongs_to :player_one, User
    belongs_to :player_two, User
    has_many :states, State, foreign_key: :game_id

    timestamps()
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:is_over, :player_one_id, :player_two_id])
    |> validate_required([:is_over, :player_one_id])
  end
end
