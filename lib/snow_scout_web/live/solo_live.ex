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
    Logger.debug "HEYyYYYYYYYYYYYYY"
    api_response =
      case HTTPoison.get(url, [], hackney: [:insecure]) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          body

        {:ok, %HTTPoison.Response{status_code: 404}} ->
          nil

        {:error, %HTTPoison.Error{reason: _reason}} ->
          nil
      end
    Logger.debug api_response
    {:ok,
     assign(socket,
       string_id: api_response
     )}
  end

  def string_in_string?(triplet, id) do
    triplet =~ id
  end


end
