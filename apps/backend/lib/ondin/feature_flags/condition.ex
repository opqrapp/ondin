defmodule Ondin.FeatureFlags.Condition do
  use Ecto.Schema
  import Ecto.Changeset

  @operators ~w(equals not_equals in not_in contains greater_than less_than)

  schema "conditions" do
    field :key, :string
    field :operator, :string
    field :value, :string
    field :values, {:array, :string}

    belongs_to :rule, Ondin.FeatureFlags.Rule

    timestamps()
  end

  @doc false
  def changeset(condition, attrs) do
    condition
    |> cast(attrs, [:key, :operator, :value, :values, :rule_id])
    |> validate_required([:key, :operator, :rule_id])
    |> validate_operator()
    |> validate_value_presence()
    |> foreign_key_constraint(:rule_id)
  end

  defp validate_operator(changeset) do
    validate_inclusion(changeset, :operator, @operators)
  end

  defp validate_value_presence(changeset) do
    operator = get_field(changeset, :operator)
    value = get_field(changeset, :value)
    values = get_field(changeset, :values)

    case operator do
      op when op in ["in", "not_in"] ->
        if is_nil(values) or values == [] do
          add_error(changeset, :values, "can't be empty for #{operator} operator")
        else
          changeset
        end
      _ ->
        if is_nil(value) do
          add_error(changeset, :value, "can't be empty for #{operator} operator")
        else
          changeset
        end
    end
  end
end
