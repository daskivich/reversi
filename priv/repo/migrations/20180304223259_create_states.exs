defmodule Reversi.Repo.Migrations.CreateStates do
  use Ecto.Migration

  def change do
    create table(:states) do
      add :player_ones_turn, :boolean, default: true, null: false
      add :r1c1, :integer, default: 0, null: false
      add :r1c2, :integer, default: 0, null: false
      add :r1c3, :integer, default: 0, null: false
      add :r1c4, :integer, default: 0, null: false
      add :r1c5, :integer, default: 0, null: false
      add :r1c6, :integer, default: 0, null: false
      add :r1c7, :integer, default: 0, null: false
      add :r1c8, :integer, default: 0, null: false
      add :r2c1, :integer, default: 0, null: false
      add :r2c2, :integer, default: 0, null: false
      add :r2c3, :integer, default: 0, null: false
      add :r2c4, :integer, default: 0, null: false
      add :r2c5, :integer, default: 0, null: false
      add :r2c6, :integer, default: 0, null: false
      add :r2c7, :integer, default: 0, null: false
      add :r2c8, :integer, default: 0, null: false
      add :r3c1, :integer, default: 0, null: false
      add :r3c2, :integer, default: 0, null: false
      add :r3c3, :integer, default: 0, null: false
      add :r3c4, :integer, default: 0, null: false
      add :r3c5, :integer, default: 0, null: false
      add :r3c6, :integer, default: 0, null: false
      add :r3c7, :integer, default: 0, null: false
      add :r3c8, :integer, default: 0, null: false
      add :r4c1, :integer, default: 0, null: false
      add :r4c2, :integer, default: 0, null: false
      add :r4c3, :integer, default: 0, null: false
      add :r4c4, :integer, default: 0, null: false
      add :r4c5, :integer, default: 0, null: false
      add :r4c6, :integer, default: 0, null: false
      add :r4c7, :integer, default: 0, null: false
      add :r4c8, :integer, default: 0, null: false
      add :r5c1, :integer, default: 0, null: false
      add :r5c2, :integer, default: 0, null: false
      add :r5c3, :integer, default: 0, null: false
      add :r5c4, :integer, default: 0, null: false
      add :r5c5, :integer, default: 0, null: false
      add :r5c6, :integer, default: 0, null: false
      add :r5c7, :integer, default: 0, null: false
      add :r5c8, :integer, default: 0, null: false
      add :r6c1, :integer, default: 0, null: false
      add :r6c2, :integer, default: 0, null: false
      add :r6c3, :integer, default: 0, null: false
      add :r6c4, :integer, default: 0, null: false
      add :r6c5, :integer, default: 0, null: false
      add :r6c6, :integer, default: 0, null: false
      add :r6c7, :integer, default: 0, null: false
      add :r6c8, :integer, default: 0, null: false
      add :r7c1, :integer, default: 0, null: false
      add :r7c2, :integer, default: 0, null: false
      add :r7c3, :integer, default: 0, null: false
      add :r7c4, :integer, default: 0, null: false
      add :r7c5, :integer, default: 0, null: false
      add :r7c6, :integer, default: 0, null: false
      add :r7c7, :integer, default: 0, null: false
      add :r7c8, :integer, default: 0, null: false
      add :r8c1, :integer, default: 0, null: false
      add :r8c2, :integer, default: 0, null: false
      add :r8c3, :integer, default: 0, null: false
      add :r8c4, :integer, default: 0, null: false
      add :r8c5, :integer, default: 0, null: false
      add :r8c6, :integer, default: 0, null: false
      add :r8c7, :integer, default: 0, null: false
      add :r8c8, :integer, default: 0, null: false
      add :game_id, references(:games, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:states, [:game_id])
  end
end
