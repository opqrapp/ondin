defmodule Ondin.Repo.Migrations.CreateRules do
  use Ecto.Migration

  def change do
    create table(:rules) do
      add :name, :string, null: false
      add :description, :text
      add :priority, :integer, default: 0, null: false
      add :is_active, :boolean, default: true, null: false
      add :feature_id, references(:features, on_delete: :delete_all), null: false
      add :variation, :map, null: false

      timestamps()
    end

    create index(:rules, [:feature_id])
    create index(:rules, [:priority])
  end
end
