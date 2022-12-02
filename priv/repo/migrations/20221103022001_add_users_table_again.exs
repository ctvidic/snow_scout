defmodule SnowScout.Repo.Migrations.AddUsersTableAgain do
  use Ecto.Migration

  def change do
    create table(:stations, primary_key: false) do
      add :latitude, :float, null: false
      add :longitude, :float, null: false
      add :name, :string, null: false
      add :triplet, :string, null: false, primary_key: true
      add :user_id, references(:users), null: false

      timestamps()
    end
  end
end
