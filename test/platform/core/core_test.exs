defmodule Platform.CoreTest do
  use Platform.DataCase

  alias Platform.Core

  describe "songs" do
    alias Platform.Core.Song

    @valid_attrs %{archived: true, band: "some band", performer_name: "some performer_name", title: "some title"}
    @update_attrs %{archived: false, band: "some updated band", performer_name: "some updated performer_name", title: "some updated title"}
    @invalid_attrs %{archived: nil, band: nil, performer_name: nil, title: nil}

    def song_fixture(attrs \\ %{}) do
      {:ok, song} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Core.create_song()

      song
    end

    test "list_songs/0 returns all songs" do
      song = song_fixture()
      assert Core.list_songs() == [song]
    end

    test "get_song!/1 returns the song with given id" do
      song = song_fixture()
      assert Core.get_song!(song.id) == song
    end

    test "create_song/1 with valid data creates a song" do
      assert {:ok, %Song{} = song} = Core.create_song(@valid_attrs)
      assert song.archived == true
      assert song.band == "some band"
      assert song.performer_name == "some performer_name"
      assert song.title == "some title"
    end

    test "create_song/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Core.create_song(@invalid_attrs)
    end

    test "update_song/2 with valid data updates the song" do
      song = song_fixture()
      assert {:ok, %Song{} = song} = Core.update_song(song, @update_attrs)

      assert song.archived == false
      assert song.band == "some updated band"
      assert song.performer_name == "some updated performer_name"
      assert song.title == "some updated title"
    end

    test "update_song/2 with invalid data returns error changeset" do
      song = song_fixture()
      assert {:error, %Ecto.Changeset{}} = Core.update_song(song, @invalid_attrs)
      assert song == Core.get_song!(song.id)
    end

    test "delete_song/1 deletes the song" do
      song = song_fixture()
      assert {:ok, %Song{}} = Core.delete_song(song)
      assert_raise Ecto.NoResultsError, fn -> Core.get_song!(song.id) end
    end

    test "change_song/1 returns a song changeset" do
      song = song_fixture()
      assert %Ecto.Changeset{} = Core.change_song(song)
    end
  end
end
