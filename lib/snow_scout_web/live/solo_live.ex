defmodule SnowScoutWeb.SoloLive do
  import Phoenix.LiveView.Helpers
  import Phoenix.LiveView
  alias SnowScout.Station
  alias SnowScout.Repo
  import Ecto.Query
  require Logger
  use SnowScoutWeb, :live_view

  def mount(%{"id" => id}, session, socket) do
    # socket = assign_defaults(session, socket)
    query = from s in Station,
      where: s.triplet == ^id
    station = Repo.all(query)
    string_id = String.slice(id, 1..-2)
    url = "http://api.powderlin.es/station/#{string_id}"

    api_response =
      case HTTPoison.get(url, [], hackney: [:insecure]) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          body

        {:ok, %HTTPoison.Response{status_code: 404}} ->
          nil

        {:error, %HTTPoison.Error{reason: _reason}} ->
          nil
      end

    {:ok,
     assign(socket,
       string_id: api_response
     )}
  end

  def string_in_string?(triplet, id) do
    triplet =~ id
  end
  def render(assigns) do
    ~H"""
    <%= @string_id %>
    """
  end


end
