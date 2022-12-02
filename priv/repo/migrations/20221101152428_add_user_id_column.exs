defmodule SnowScout.Repo.Migrations.AddUserIdColumn do
  use Ecto.Migration

  def change do
    alter table("stations") do
      add :user_id, references(:users), null: false
    end
  end
end
