defmodule PlatformWeb.PageController do
  use PlatformWeb, :controller

  def index(conn, _params) do
    songs = Platform.Core.list_next_songs()
    # sollte immer am Schluss stehen, Ruby/Rails macht da sehr viel Magic, weswegen die Reihenfolge dort egal ist
    render(conn, "index.html", songs: songs)
  end
end
