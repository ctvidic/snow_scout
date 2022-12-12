# SnowScout

SnowScout is a website built for providing up to date snowfall info received from SNOTEL sites. A SNOTEL site is a fancy name for a backcountry weather station that measures snow and transmits the data wirelessly. SnowScout uses a cloned and deployed version of the [powderlines api](https://github.com/bobbymarko/powderlines-api) for access to daily info. 

<img width="643" alt="image" src="https://user-images.githubusercontent.com/80602202/206814053-f9aa6c18-9d50-4f94-847d-5d866853b64a.png">


SnowScout was created as an exercise in creating a simple CRUD application using Phoenix Liveview. SnowScout allows users to create an account and save or delete stations that they are interested in. Users can then monitor and keep up to date with the saved stations.

Project created using Elixir, Mapbox API, ApexCharts, and Tailwind.

------------------------

SnowScout is not running in production, but this repo can be cloned and ran following the instructions below.

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
