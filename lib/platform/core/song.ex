defmodule Platform.Core.Song do
  use Ecto.Schema
  import Ecto.Changeset


  schema "songs" do
    field :archived, :boolean, default: false
    field :band, :string
    field :performer_name, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(song, attrs) do
    song
    |> cast(attrs, [:band, :title, :performer_name, :archived])
    |> validate_required([:band, :title, :performer_name, :archived])
  end
end
