defmodule Ondin.FeatureFlags.Rule do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rules" do
    field :name, :string
    field :description, :string
    field :priority, :integer, default: 0
    field :is_active, :boolean, default: true
    field :variation, :map

    belongs_to :feature, Ondin.FeatureFlags.Feature
    has_many :conditions, Ondin.FeatureFlags.Condition

    timestamps()
  end

  @doc false
  def changeset(rule, attrs) do
    rule
    |> cast(attrs, [:name, :description, :priority, :is_active, :variation, :feature_id])
    |> validate_required([:name, :variation, :feature_id])
    |> validate_number(:priority, greater_than_or_equal_to: 0)
    |> validate_variation(:variation)
    |> foreign_key_constraint(:feature_id)
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
