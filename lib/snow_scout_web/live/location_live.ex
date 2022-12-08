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
    length = String.length(triplet)
    if length == 13 do
      "https://wcc.sc.egov.usda.gov/nwcc/site?sitenum="<>String.slice(triplet, 1..3)
    else
      "https://wcc.sc.egov.usda.gov/nwcc/site?sitenum="<>String.slice(triplet, 1..4)
    end
  end

  def render(assigns) do
    ~H"""
      <div class="flex flex-col items-center w-1000 !important">
        <%= for station <- @stations do %>
        <div class="weather-card w-1000">
          <li>Station Name: <%= inspect station.name %></li>
          <li>Lat: <%= inspect station.latitude %> Lng: <%= inspect station.longitude %></li>
          <li><%= inspect station.triplet %></li>
          <li><a href={parse_triplet(station.triplet)} target="_blank">Snotel Link </a></li>
          <li><%= link "Station Page", to: Routes.solo_path(@socket, :show, station.triplet)%></li>
        </div>
      <% end %>
      </div>
    """
  end
end
