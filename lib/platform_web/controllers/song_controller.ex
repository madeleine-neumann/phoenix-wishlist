defmodule PlatformWeb.SongController do
  use PlatformWeb, :controller
  plug PlatformWeb.BasicAuth, [username: "user", password: "secret"] when action not in [:new, :create]

  alias Platform.Core
  alias Platform.Core.Song

  def index(conn, _params) do
    next_songs = Core.list_next_songs()
    archived_songs = Core. list_archived_songs()
    render(conn, "index.html", next_songs: next_songs, archived_songs: archived_songs )
  end

  def new(conn, _params) do
    changeset = Core.change_song(%Song{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"song" => song_params}) do
    case Core.create_song(song_params) do
      {:ok, song} ->
        template = Phoenix.View.render_to_string(PlatformWeb.PageView, "_song.html", song: song)
        PlatformWeb.Endpoint.broadcast! "song:lobby", "new_song", %{template: template}

        conn
        |> put_flash(:info, "Song created successfully.")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "song" => song_params}) do
    song = Core.get_song!(id)

    case Core.update_song(song, song_params) do
      {:ok, song} ->
        conn
        |> put_flash(:info, "Song updated successfully.")
        |> redirect(to: Routes.song_path(conn, :show, song))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", song: song, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id, "force" => "true"}) do
    song = Core.get_song!(id)
    {:ok, _song} = Core.delete_song(song)

    conn
    |> put_flash(:info, "Song deleted successfully.")
    |> redirect(to: Routes.song_path(conn, :index))
  end

  def delete(conn, %{"id" => id}) do
    song = Core.get_song!(id)
    {:ok, _song} = Core.archive_song(song)

    conn
    |> put_flash(:info, "Song archived successfully.")
    |> redirect(to: Routes.song_path(conn, :index))
  end
end
