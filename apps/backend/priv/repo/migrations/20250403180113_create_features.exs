defmodule Ondin.Repo.Migrations.CreateFeatures do
  use Ecto.Migration

  def change do
    create table(:features) do
      add :name, :string, null: false
      add :key, :string, null: false
      add :description, :text
      add :is_active, :boolean, default: true, null: false
      add :default_variation, :map, null: false
      add :project_id, references(:projects, on_delete: :delete_all), null: false

      timestamps()
    end

    create unique_index(:features, [:project_id, :key])
    create index(:features, [:name])
    create index(:features, [:project_id])
  end
end
