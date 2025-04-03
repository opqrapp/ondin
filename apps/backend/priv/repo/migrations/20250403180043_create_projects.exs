defmodule Ondin.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :name, :string, null: false
      add :key, :string, null: false
      add :description, :text
      add :is_active, :boolean, default: true, null: false

      timestamps()
    end

    create unique_index(:projects, [:key])
    create index(:projects, [:name])
  end
end
