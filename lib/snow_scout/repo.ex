defmodule SnowScout.Repo do
  use Ecto.Repo,
    otp_app: :snow_scout,
    adapter: Ecto.Adapters.Postgres
end
