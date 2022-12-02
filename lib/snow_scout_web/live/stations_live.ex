defmodule SnowScoutWeb.StationsLive do
  use SnowScoutWeb, :live_view
  alias SnowScout.Station
  alias SnowScout.Repo
  require Logger
  require Jason
  @impl true

  def mount(_params, session, socket) do
    socket = assign_defaults(session, socket)

    {:ok,
     assign(socket,
       edit_mode: false,
       menu_choice: "summary_historical",
       selected_location: '',
       api_response: '',
       station_name: '',
       station_info: '',
       data: '',
       user_stations: '',
       lat: '',
       lng: '',
       triplet: ''
     )}
  end

  @impl true
  def handle_event(
        "selected_location",
        %{"location" => %{"lat" => latitude, "lng" => longitude}},
        socket
      ) do
    location_name = "#{Float.round(latitude, 4)}, #{Float.round(longitude, 4)}"
    location_attrs = %{latitude: latitude, longitude: longitude, name: location_name}

    lat = Map.get(location_attrs, :latitude)
    long = Map.get(location_attrs, :longitude)

    url =
      "http://api.powderlin.es/closest_stations?lat=#{lat}&lng=#{long}&data=true&days=7&count=7"
    Logger.info url
    api_response =
      case HTTPoison.get(url, [], hackney: [:insecure]) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          parse_api_string(body)

        {:ok, %HTTPoison.Response{status_code: 404}} ->
          nil

        {:error, %HTTPoison.Error{reason: _reason}} ->
          nil
      end
    Logger.info api_response

    if api_response != nil do
      api_map = Poison.decode!(api_response)
      values_listed = map_to_list(Map.fetch!(List.first(api_map),"data"))
      triplet = Map.fetch!(Map.fetch!(List.last(api_map),"station_information"),"triplet")
      station_name = Map.fetch!(Map.fetch!(List.last(api_map),"station_information"),"name")
      station_info = Map.fetch!(Map.fetch!(List.last(api_map),"station_information"),"location")
      station_elevation = Map.fetch!(Map.fetch!(List.last(api_map),"station_information"),"elevation")
      {:noreply,
      push_event(socket, "clicked", %{api_response: values_listed, station_name: station_name, station_info: station_info, station_elevation: station_elevation, triplet: triplet})}
    else
      {:noreply, socket}
    end
  end




  @impl true
  def handle_event("save_station", data , socket) do
    lng = Map.fetch!(data, "lng")
    lat = Map.fetch!(data, "lat")
    station_name = Map.fetch!(data, "station_name")
    triplet = Map.fetch!(data, "triplet")
    new_data = %{}
    full_attrs =
      new_data
      |> Map.put(:longitude, lng)
      |> Map.put(:latitude, lat)
      |> Map.put(:station_name, station_name)
      |> Map.put(:triplet, triplet)

    case Station.create_location(socket.assigns.current_user, full_attrs) do
      {:ok, location} ->
        stations = Repo.all(Station, user_id: socket.assigns.current_user.id)
        {:noreply, assign(socket,data: new_data, user_stations: stations)}
    end
    # add in new attributes, set the user and insert the location into the database
  end

  @impl true
  def handle_event("assign_data", data, socket) do
    lng = Map.fetch!(data, "lng")
    lat = Map.fetch!(data, "lat")
    station_name = Map.fetch!(data, "station_name")
    triplet = Map.fetch!(data, "triplet")
    {:noreply, assign(socket, lng: lng, lat: lat, station_name: station_name, triplet: triplet)}
  end

  @impl true
  defp map_to_list([]) do
    []
  end

  @impl true
  defp map_to_list([ x | rest]) do
     map_to_list(rest) ++ [Map.fetch!(x, "Snow Depth (in)")]
  end

  @impl true
  defp parse_string(api_response) do
    Logger.info Poison.decode(api_response)
  end

  @impl true
  def handle_event("clear_location", _params, socket) do
    {:noreply, assign(socket, selected_location: [], api_response: '')}
  end
  # def render(assigns) do
  #   ~H"""
  #   Current temperature:
  #   """
  # end

  defp parse_api_string(api_string) do
    api_string
  end

  @impl true
  def handle_event("save_location", _params, socket) do
    Logger.info socket
    {:noreply, socket}
  end
end
