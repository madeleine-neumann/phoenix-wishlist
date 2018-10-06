defmodule Platform.Repo.Migrations.CreateSongs do
  use Ecto.Migration

  def change do
    create table(:songs) do
      add :band, :string, null: false
      add :title, :string, null: false
      add :performer_name, :string, null: false
      add :archived, :boolean, default: false, null: false

      timestamps()
    end

  end
end
