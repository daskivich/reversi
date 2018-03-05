defmodule Reversi.Play.State do
  use Ecto.Schema
  import Ecto.Changeset

  alias Reversi.Play.Game

  schema "states" do
    field :r2c6, :integer, default: 0
    field :r5c3, :integer, default: 0
    field :r2c8, :integer, default: 0
    field :r3c6, :integer, default: 0
    field :r4c1, :integer, default: 0
    field :r5c4, :integer, default: 0
    field :r1c5, :integer, default: 0
    field :r8c4, :integer, default: 0
    field :r4c5, :integer, default: 0
    field :r6c8, :integer, default: 0
    field :r1c6, :integer, default: 0
    field :r8c1, :integer, default: 0
    field :r4c3, :integer, default: 0
    field :r8c7, :integer, default: 0
    field :r2c7, :integer, default: 0
    field :r5c8, :integer, default: 0
    field :r7c7, :integer, default: 0
    field :r2c5, :integer, default: 0
    field :r8c3, :integer, default: 0
    field :r8c5, :integer, default: 0
    field :r8c6, :integer, default: 0
    field :r1c8, :integer, default: 0
    field :r4c6, :integer, default: 0
    field :r7c5, :integer, default: 0
    field :r6c2, :integer, default: 0
    field :r8c8, :integer, default: 0
    field :r7c6, :integer, default: 0
    field :r2c3, :integer, default: 0
    field :r6c1, :integer, default: 0
    field :r2c1, :integer, default: 0
    field :r7c3, :integer, default: 0
    field :r3c5, :integer, default: 0
    field :r4c7, :integer, default: 0
    field :r2c4, :integer, default: 0
    field :r4c8, :integer, default: 0
    field :r3c1, :integer, default: 0
    field :r1c7, :integer, default: 0
    field :r7c8, :integer, default: 0
    field :r6c6, :integer, default: 0
    field :r7c4, :integer, default: 0
    field :r6c3, :integer, default: 0
    field :r3c7, :integer, default: 0
    field :r6c4, :integer, default: 0
    field :r4c2, :integer, default: 0
    field :r1c2, :integer, default: 0
    field :r5c1, :integer, default: 0
    field :r8c2, :integer, default: 0
    field :r6c7, :integer, default: 0
    field :r7c1, :integer, default: 0
    field :player_ones_turn, :boolean, default: true
    field :r3c4, :integer, default: 0
    field :r5c7, :integer, default: 0
    field :r5c6, :integer, default: 0
    field :r3c8, :integer, default: 0
    field :r2c2, :integer, default: 0
    field :r5c5, :integer, default: 0
    field :r4c4, :integer, default: 0
    field :r5c2, :integer, default: 0
    field :r7c2, :integer, default: 0
    field :r1c3, :integer, default: 0
    field :r1c1, :integer, default: 0
    field :r1c4, :integer, default: 0
    field :r3c3, :integer, default: 0
    field :r3c2, :integer, default: 0
    field :r6c5, :integer, default: 0
    belongs_to :game, Game

    timestamps()
  end

  @doc false
  def changeset(state, attrs) do
    state
    |> cast(attrs, [:player_ones_turn, :r1c1, :r1c2, :r1c3, :r1c4, :r1c5, :r1c6, :r1c7, :r1c8, :r2c1, :r2c2, :r2c3, :r2c4, :r2c5, :r2c6, :r2c7, :r2c8, :r3c1, :r3c2, :r3c3, :r3c4, :r3c5, :r3c6, :r3c7, :r3c8, :r4c1, :r4c2, :r4c3, :r4c4, :r4c5, :r4c6, :r4c7, :r4c8, :r5c1, :r5c2, :r5c3, :r5c4, :r5c5, :r5c6, :r5c7, :r5c8, :r6c1, :r6c2, :r6c3, :r6c4, :r6c5, :r6c6, :r6c7, :r6c8, :r7c1, :r7c2, :r7c3, :r7c4, :r7c5, :r7c6, :r7c7, :r7c8, :r8c1, :r8c2, :r8c3, :r8c4, :r8c5, :r8c6, :r8c7, :r8c8, :game_id])
    |> validate_required([:player_ones_turn, :game_id])
  end
end
