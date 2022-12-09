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
    values_listed = precip_values(api_response)

    {:ok,
      push_event(socket, "update_station", %{lat: lng,lng: lat})}
  end

  def precip_values(api_response) do
    decode = Poison.decode!(api_response)
    vals = Map.fetch!(decode,"data")
    Logger.info vals
    snow_vals = map_to_list(vals)
    Logger.info snow_vals
    vals
  end

  def find_lat(api_response) do
      decode = Poison.decode!(api_response)
      val = Map.fetch!(decode,"station_information")
      location = Map.fetch!(val,"location")
      lat = Map.fetch!(location, "lat")
      lat
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

  defp map_to_list([]) do
    []
  end

  @impl true
  defp map_to_list([ x | rest]) do
     map_to_list(rest) ++ [Map.fetch!(x, "Snow Depth (in)")]
  end

  def handle_event("delete_station", data , socket) do
    Logger.info data
    # add in new attributes, set the user and insert the location into the database
  end

end
