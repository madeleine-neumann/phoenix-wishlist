defmodule Platform.Core do
  @moduledoc """
  The Core context.
  """

  import Ecto.Query, warn: false
  alias Platform.Repo

  alias Platform.Core.Song

  @doc """
  Returns the list of songs.
  """
  def list_songs do
    Song
    |> order_by(asc: :inserted_at)
    |> Repo.all()
  end

  def list_next_songs do
    Song
    |> where(archived: false)
    |> order_by(asc: :inserted_at)
    |> Repo.all()
  end

  def list_archived_songs do
    Song
    |> where(archived: true)
    |> order_by(asc: :inserted_at)
    |> Repo.all()
  end

  def archive_song(%Song{} = song) do
    song
    |> Song.changeset(%{archived: true})
    |> Repo.update()
  end

  @doc """
  Gets a single song.

  Raises `Ecto.NoResultsError` if the Song does not exist.
  """
  def get_song!(id), do: Repo.get!(Song, id)

  @doc """
  Creates a song.
  """
  def create_song(attrs \\ %{}) do
    %Song{}
    |> Song.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a song.
  """
  def update_song(%Song{} = song, attrs) do
    song
    |> Song.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Song.
  """
  def delete_song(%Song{} = song) do
    Repo.delete(song)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking song changes.
  """
  def change_song(%Song{} = song) do
    Song.changeset(song, %{})
  end
end
