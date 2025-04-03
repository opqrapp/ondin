defmodule Ondin.Repo.Migrations.CreateSettings do
  use Ecto.Migration

  def change do
    create table(:settings) do
      add :key, :string, null: false
      add :value, :text
      add :description, :text
      add :type, :string, default: "string"

      timestamps()
    end

    # Create a unique index on key to enforce uniqueness
    create unique_index(:settings, [:key])
  end
end
