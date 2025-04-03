defmodule Ondin.FeatureFlags.Feature do
  use Ecto.Schema
  import Ecto.Changeset

  schema "features" do
    field :name, :string
    field :key, :string
    field :description, :string
    field :is_active, :boolean, default: true
    field :default_variation, :map

    belongs_to :project, Ondin.FeatureFlags.Project
    has_many :rules, Ondin.FeatureFlags.Rule

    timestamps()
  end

  @doc false
  def changeset(feature, attrs) do
    feature
    |> cast(attrs, [:name, :key, :description, :is_active, :default_variation, :project_id])
    |> validate_required([:name, :key, :default_variation, :project_id])
    |> validate_length(:name, min: 1, max: 255)
    |> validate_length(:key, min: 1, max: 50)
    |> validate_format(:key, ~r/^[a-z0-9_-]+$/, message: "must contain only lowercase letters, numbers, underscores, and hyphens")
    |> validate_variation(:default_variation)
    |> foreign_key_constraint(:project_id)
    |> unique_constraint([:project_id, :key])
  end

  defp validate_variation(changeset, field) do
    validate_change(changeset, field, fn _, variation ->
      # Allow any valid JSON value as a variation
      # You can add more specific validation rules here if needed
      if is_map(variation) do
        []
      else
        [{field, "must be a valid map"}]
      end
    end)
  end
end
