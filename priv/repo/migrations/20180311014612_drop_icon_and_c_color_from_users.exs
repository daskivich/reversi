defmodule Reversi.Repo.Migrations.DropIconAndCColorFromUsers do
  use Ecto.Migration

  def change do
    alter table("users") do
      remove :color_primary
      remove :color_secondary
      remove :icon_primary
      remove :icon_secondary
    end
  end
end
