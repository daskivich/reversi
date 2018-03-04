defmodule Reversi.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :color_primary, :string
    field :color_secondary, :string
    field :email, :string
    field :icon_primary, :string
    field :icon_secondary, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :icon_primary, :icon_secondary, :color_primary, :color_secondary])
    |> validate_required([:name, :email, :icon_primary, :icon_secondary, :color_primary, :color_secondary])
    |> unique_constraint(:email)
  end
end
