defmodule SnowScoutWeb.SoloLive do
  use SnowScoutWeb, :live_view
  import Phoenix.LiveView.Helpers
  import Phoenix.LiveView
  alias SnowScout.Station
  alias SnowScout.Repo
  import Ecto.Query
  require Logger

  @impl true
  def mount(%{"id" => id}, session, socket) do
    # socket = assign_defaults(session, socket)
    query = from s in Station,
      where: s.triplet == ^id
    station = Repo.all(query)
    string_id = String.slice(id, 1..-2)
    url = "https://snowscout.herokuapp.com/station/#{string_id}"


    api_response =
      case HTTPoison.get(url, [], hackney: [:insecure]) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          body

        {:ok, %HTTPoison.Response{status_code: 404}} ->
          nil

        {:error, %HTTPoison.Error{reason: _reason}} ->
          nil
      end

    lat = find_lat(api_response)
    lng = find_lng(api_response)
    data_station = [lat,lng]
    values_listed = list_to_string(precip_values(api_response))
    {:ok,
    assign(socket,
      edit_mode: false,
      lng_solo: lng,
      lat_solo: lat,
      precip_string: values_listed,
      precip_values: '',
      data: ''
    )}

  end

  def precip_values(api_response) do
    decode = Poison.decode!(api_response)
    vals = Map.fetch!(decode,"data")
    vals
  end

  def find_lat(api_response) do
      decode = Poison.decode!(api_response)
      val = Map.fetch!(decode,"station_information")
      location = Map.fetch!(val,"location")
      lat = Map.fetch!(location, "lat")
      lat
  end

  def handle_event("assign_station", _params,socket) do
    station_strings = list_to_string(socket.assigns.precip_values)
    Logger.info station_strings
    {:noreply, assign(socket, precip_string: station_strings)}
  end

  def find_lng(api_response) do
    decode = Poison.decode!(api_response)
    val = Map.fetch!(decode,"station_information")
    location = Map.fetch!(val,"location")
    lng = Map.fetch!(location, "lng")
    lng
  end

  def string_in_string?(triplet, id) do
    triplet =~ id
  end

  @impl true
  defp list_to_list([ x | rest]) do
     list_to_list(rest) ++ [Map.fetch!(x, "Snow Depth (in)")]
  end

  defp list_to_list([]) do
    []
  end

  @impl true
  defp list_to_string([ x | rest]) do
     if Map.fetch!(x, "Snow Depth (in)") == nil do
      list_to_string(rest) <> "X" <> "N"
     else
      list_to_string(rest) <> "X" <> Map.fetch!(x, "Snow Depth (in)")
     end
  end

  defp list_to_string([]) do
    "X"
  end



  def handle_event("delete_station", data , socket) do
    lat = socket.assigns
    Logger.info "get?"
    Logger.info socket.assigns.lat_solo
    x= Repo.get_by(Station, latitude: socket.assigns.lat_solo)
    Logger.info "got?"

    Logger.info "delete?"
    Repo.delete(x)
    {:noreply, socket}
  end

end
