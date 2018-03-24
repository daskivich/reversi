defmodule Reversi.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Reversi.Play.Game

  schema "users" do
    field :email, :string # must be unique
    field :name, :string

    field :password_hash, :string # hash value of this user's password
    field :pw_tries, :integer # a running count of attempted log-ins
    field :pw_last_try, :utc_datetime # time of last attempted log-in

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true # must match password

    has_many :player_one_games, Game, foreign_key: :player_one_id
    has_many :player_two_games, Game, foreign_key: :player_two_id
    has_many :player_one_opponents, through: [:player_two_games, :player_one]
    has_many :player_two_opponents, through: [:player_one_games, :player_two]

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password, :password_confirmation, :pw_tries, :pw_last_try])
    |> validate_confirmation(:password)
    |> validate_password(:password)
    |> put_pass_hash()
    |> validate_required([:name, :email, :password_hash])
    |> unique_constraint(:email)
  end

  # method to validate password from Comonin docs
  # https://hexdocs.pm/comeonin/Comeonin.Argon2.html
  def validate_password(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, password ->
      case valid_password?(password) do
        {:ok, _} -> []
        {:error, msg} -> [{field, options[:message] || msg}]
      end
    end)
  end

  # password validation helper method from Nat's Notes
  # http://www.ccs.neu.edu/home/ntuck/courses/2018/01/cs4550/notes/17-passwords/notes.html
  def valid_password?(password) when byte_size(password) > 7 do
    {:ok, password}
  end
  def valid_password?(_), do: {:error, "The password is too short"}

  # method to add password hash to the changeset from Nat's Notes
  # http://www.ccs.neu.edu/home/ntuck/courses/2018/01/cs4550/notes/17-passwords/notes.html
  def put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Comeonin.Argon2.add_hash(password))
  end
  def put_pass_hash(changeset), do: changeset
end
