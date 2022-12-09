defmodule SnowScoutWeb.LocationsLive do
  require Logger
  use SnowScoutWeb, :live_view
  alias SnowScout.Station
  alias SnowScout.Repo
  require Logger
  require Jason
  @impl true
  def mount(_params, session, socket) do
    socket = assign_defaults(session, socket)
    stations = Repo.all(Station, user_id: socket.assigns.current_user.id)
    {:ok,
     assign(socket,
       stations: stations
     )}
  end

  def snowfall_amount(triplet) do
    url_trim = "https://snowscout.herokuapp.com/station/#{triplet}"
    url = String.replace(url_trim, ~s("), "")
    api_response=
      case HTTPoison.get(url, [], hackney: [:insecure]) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          body

        {:ok, %HTTPoison.Response{status_code: 404}} ->
          nil

        {:error, %HTTPoison.Error{reason: _reason}} ->
          nil
      end
    api_response
    if api_response != nil do
      api_decode = Poison.decode!(api_response)
      api_parsed = List.last(Map.fetch!(api_decode,"data"))
      last_val = Map.fetch!(api_parsed, "Snow Depth (in)")
      last_val
    else
      "N/A"
    end

  end

  def parse_triplet(triplet) do
    length = String.length(triplet)
    if length == 13 do
      "https://wcc.sc.egov.usda.gov/nwcc/site?sitenum="<>String.slice(triplet, 1..3)
    else
      "https://wcc.sc.egov.usda.gov/nwcc/site?sitenum="<>String.slice(triplet, 1..4)
    end
  end

  def handle_event("delete_station", data , socket) do
      Logger.debug data
  end

  def render(assigns) do
    ~H"""
      <div class="flex flex-col items-center w-1000 !important">
        <%= for station <- @stations do %>
        <div class="flex flex-row weather-card w-1000 dark:bg-gray-200 dark:border-gray-100 justify-between">
          <div>
            <div class="text-lg font-semibold text-gray-900 dark:text-black"><%= inspect String.trim(station.name, ~S["]) %></div>
            <div class="text-sm font-medium mb-3">Lat: <%= inspect station.latitude %> Lng: <%= inspect station.longitude %></div>
            <div class="text-m font-medium hover:text-gray-600"><a href={parse_triplet(station.triplet)} target="_blank">Snotel Link </a></div>
            <div  class="text-m font-medium hover:text-gray-600"><%= link "Station Page", to: Routes.solo_path(@socket, :show, station.triplet)%></div>
          </div>
          <div class="flex flex-row justify-start	">
              <div class="text-6xl font-semibold"><%= snowfall_amount(station.triplet)%></div>
              <div class="text-2xl font-semibold">in </div>
          </div>
        </div>
      <% end %>
      </div>
    """
  end
end
