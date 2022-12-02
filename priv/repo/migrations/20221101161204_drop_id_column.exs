defmodule SnowScout.Repo.Migrations.DropIdColumn do
  use Ecto.Migration

  def change do
    alter table("stations") do
      remove :id
    end
  end
end
