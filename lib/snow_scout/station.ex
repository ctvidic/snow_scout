defmodule SnowScout.Station do
  use Ecto.Schema
  import Ecto.Changeset
  alias SnowScout.Accounts.User
  alias SnowScout.Station
  alias SnowScout.Repo
  require Logger
  require Jason

  @primary_key {:triplet, :string, []}
  @derive {Phoenix.Param, key: :triplet}
  schema "stations" do
    field :latitude, :float
    field :longitude, :float
    field :name, :string

    belongs_to :user, SnowScout.Accounts.User

    timestamps()
  end

  def create_location(%User{} = user, attrs) do

    new_map = %{}
    full_attrs =
      new_map
      |> Map.put(:longitude, Map.fetch!(attrs, :longitude))
      |> Map.put(:latitude, Map.fetch!(attrs, :latitude))
      |> Map.put(:name, Map.fetch!(attrs, :station_name))
      |> Map.put(:triplet, Map.fetch!(attrs, :triplet))
    station =
      %Station{}
      |> Station.changeset(full_attrs)
      |> Ecto.Changeset.put_assoc(:user, user)
      |> Repo.insert()
      |> broadcast_location(:location_created)
  end

  def changeset(station, attrs) do
    required_fields = [:latitude, :longitude, :name, :triplet]
    station
    |> cast(attrs,required_fields)
    |> assoc_constraint(:user)
  end

  defp parse_api_string(api_string) do
    api_string
  end

  defp broadcast_location({:ok, location}, event) do
    {:ok, location}
  end
end
