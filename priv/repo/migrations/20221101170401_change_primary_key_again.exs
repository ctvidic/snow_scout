defmodule SnowScout.Repo.Migrations.ChangePrimaryKeyAgain do
  use Ecto.Migration

  def change do
    create table(:stations, primary_key: false) do
      add :latitude, :float, null: false
      add :longitude, :float, null: false
      add :name, :string, null: false, primary_key: true

      timestamps()
    end
   end
end
