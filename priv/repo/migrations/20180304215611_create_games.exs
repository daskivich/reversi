defmodule Reversi.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :is_over, :boolean, default: false, null: false
      add :player_one_id, references(:users, on_delete: :delete_all), null: false
      add :player_two_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:games, [:player_one_id])
    create index(:games, [:player_two_id])
  end
end
