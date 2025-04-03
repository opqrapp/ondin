defmodule Ondin.Repo.Migrations.CreateConditions do
  use Ecto.Migration

  def change do
    create table(:conditions) do
      add :key, :string, null: false
      add :operator, :string, null: false
      add :value, :string
      add :values, {:array, :string}
      add :rule_id, references(:rules, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:conditions, [:rule_id])
    create index(:conditions, [:key])
  end
end
