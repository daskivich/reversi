defmodule Reversi.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Reversi.Play.Game

  schema "users" do
    field :email, :string
    field :name, :string
    has_many :player_one_games, Game, foreign_key: :player_one_id
    has_many :player_two_games, Game, foreign_key: :player_two_id
    has_many :player_one_opponents, through: [:player_two_games, :player_one]
    has_many :player_two_opponents, through: [:player_one_games, :player_two]

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
    |> unique_constraint(:email)
  end
end
