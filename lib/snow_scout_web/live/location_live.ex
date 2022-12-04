defmodule SnowScoutWeb.LocationsLive do
  require Logger
  use SnowScoutWeb, :live_view
  alias SnowScout.Station
  alias SnowScout.Repo
  @impl true
  def mount(_params, session, socket) do
    socket = assign_defaults(session, socket)
    stations = Repo.all(Station, user_id: socket.assigns.current_user.id)
    {:ok,
     assign(socket,
       stations: stations
     )}
  end

  def parse_triplet(triplet) do
    "https://wcc.sc.egov.usda.gov/nwcc/site?sitenum="<>String.slice(triplet, 1..3)
  end

  def render(assigns) do
    ~H"""
      <%= for station <- @stations do %>
      <div class="weather-card">
        <li>Station Name: <%= inspect station.name %></li>
        <li>Lat: <%= inspect station.latitude %> Lng: <%= inspect station.longitude %></li>
        <li><%= inspect station.triplet %></li>
        <li><a href={parse_triplet(station.triplet)} target="_blank">Snotel Link </a></li>
        <li><%= link "Station Page", to: Routes.solo_path(@socket, :show, station.triplet)%></li>
      </div>
    <% end %>
    """
  end
end
