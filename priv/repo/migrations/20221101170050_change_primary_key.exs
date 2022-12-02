defmodule SnowScout.Repo.Migrations.ChangePrimaryKey do
  use Ecto.Migration

   def change do
      drop table(:stations)
   end
end
