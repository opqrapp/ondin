defmodule Ondin.FeatureFlags.Project do
  use Ecto.Schema
  import Ecto.Changeset

  schema "projects" do
    field :name, :string
    field :key, :string
    field :description, :string
    field :is_active, :boolean, default: true

    has_many :features, Ondin.FeatureFlags.Feature

    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:name, :key, :description, :is_active])
    |> validate_required([:name, :key])
    |> validate_length(:name, min: 1, max: 255)
    |> validate_length(:key, min: 1, max: 50)
    |> validate_format(:key, ~r/^[a-z0-9_-]+$/, message: "must contain only lowercase letters, numbers, underscores, and hyphens")
    |> unique_constraint(:key)
  end
end
