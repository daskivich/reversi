defmodule Reversi.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false
      add :email, :string, null: false
      add :icon_primary, :string, null: false
      add :icon_secondary, :string, null: false
      add :color_primary, :string, null: false
      add :color_secondary, :string, null: false

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
