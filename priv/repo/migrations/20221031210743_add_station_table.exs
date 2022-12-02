defmodule SnowScout.Repo.Migrations.AddStationTable do
  use Ecto.Migration

  def change do
    create table(:stations, primary_key: false) do
      add :id, :string, primary_key: true
      add :latitude, :float, null: false
      add :longitude, :float, null: false
      add :name, :string, null: false

      timestamps()
    end

    create unique_index(:stations, [:id])
  end
end
