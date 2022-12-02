defmodule SnowScout.Repo.Migrations.DropUsersTableAgain do
  use Ecto.Migration

   def change do
      drop table(:stations)
   end
end
