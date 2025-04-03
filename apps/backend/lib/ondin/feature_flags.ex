defmodule Ondin.FeatureFlags do
  @moduledoc """
  The FeatureFlags context.
  """

  import Ecto.Query, warn: false
  alias Ondin.Repo

  alias Ondin.FeatureFlags.Project
  alias Ondin.FeatureFlags.Feature
  alias Ondin.FeatureFlags.Rule
  alias Ondin.FeatureFlags.Condition

  # Project functions

  @doc """
  Returns the list of projects.

  ## Examples

      iex> list_projects()
      [%Project{}, ...]

  """
  def list_projects do
    Repo.all(Project)
  end

  @doc """
  Gets a single project.

  Raises `Ecto.NoResultsError` if the Project does not exist.

  ## Examples

      iex> get_project!(123)
      %Project{}

      iex> get_project!(456)
      ** (Ecto.NoResultsError)

  """
  def get_project!(id), do: Repo.get!(Project, id)

  @doc """
  Gets a single project by key.

  Returns nil if the Project does not exist.

  ## Examples

      iex> get_project_by_key("my-project")
      %Project{}

      iex> get_project_by_key("non-existent")
      nil

  """
  def get_project_by_key(key), do: Repo.get_by(Project, key: key)

  @doc """
  Creates a project.

  ## Examples

      iex> create_project(%{field: value})
      {:ok, %Project{}}

      iex> create_project(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_project(attrs \\ %{}) do
    %Project{}
    |> Project.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a project.

  ## Examples

      iex> update_project(project, %{field: new_value})
      {:ok, %Project{}}

      iex> update_project(project, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_project(%Project{} = project, attrs) do
    project
    |> Project.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a project.

  ## Examples

      iex> delete_project(project)
      {:ok, %Project{}}

      iex> delete_project(project)
      {:error, %Ecto.Changeset{}}

  """
  def delete_project(%Project{} = project) do
    Repo.delete(project)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking project changes.

  ## Examples

      iex> change_project(project)
      %Ecto.Changeset{data: %Project{}}

  """
  def change_project(%Project{} = project, attrs \\ %{}) do
    Project.changeset(project, attrs)
  end

  # Feature functions

  @doc """
  Returns the list of features for a project.

  ## Examples

      iex> list_features(project_id)
      [%Feature{}, ...]

  """
  def list_features(project_id) do
    Feature
    |> where([f], f.project_id == ^project_id)
    |> Repo.all()
  end

  @doc """
  Gets a single feature.

  Raises `Ecto.NoResultsError` if the Feature does not exist.

  ## Examples

      iex> get_feature!(123)
      %Feature{}

      iex> get_feature!(456)
      ** (Ecto.NoResultsError)

  """
  def get_feature!(id), do: Repo.get!(Feature, id)

  @doc """
  Gets a single feature by project and key.

  Returns nil if the Feature does not exist.

  ## Examples

      iex> get_feature_by_key(project_id, "my-feature")
      %Feature{}

      iex> get_feature_by_key(project_id, "non-existent")
      nil

  """
  def get_feature_by_key(project_id, key) do
    Repo.get_by(Feature, project_id: project_id, key: key)
  end

  @doc """
  Creates a feature.

  ## Examples

      iex> create_feature(%{field: value})
      {:ok, %Feature{}}

      iex> create_feature(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_feature(attrs \\ %{}) do
    %Feature{}
    |> Feature.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a feature.

  ## Examples

      iex> update_feature(feature, %{field: new_value})
      {:ok, %Feature{}}

      iex> update_feature(feature, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_feature(%Feature{} = feature, attrs) do
    feature
    |> Feature.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a feature.

  ## Examples

      iex> delete_feature(feature)
      {:ok, %Feature{}}

      iex> delete_feature(feature)
      {:error, %Ecto.Changeset{}}

  """
  def delete_feature(%Feature{} = feature) do
    Repo.delete(feature)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking feature changes.

  ## Examples

      iex> change_feature(feature)
      %Ecto.Changeset{data: %Feature{}}

  """
  def change_feature(%Feature{} = feature, attrs \\ %{}) do
    Feature.changeset(feature, attrs)
  end

  # Rule functions

  @doc """
  Returns the list of rules for a feature.

  ## Examples

      iex> list_rules(feature_id)
      [%Rule{}, ...]

  """
  def list_rules(feature_id) do
    Rule
    |> where([r], r.feature_id == ^feature_id)
    |> order_by([r], asc: r.priority)
    |> Repo.all()
  end

  @doc """
  Gets a single rule.

  Raises `Ecto.NoResultsError` if the Rule does not exist.

  ## Examples

      iex> get_rule!(123)
      %Rule{}

      iex> get_rule!(456)
      ** (Ecto.NoResultsError)

  """
  def get_rule!(id), do: Repo.get!(Rule, id)

  @doc """
  Creates a rule.

  ## Examples

      iex> create_rule(%{field: value})
      {:ok, %Rule{}}

      iex> create_rule(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_rule(attrs \\ %{}) do
    %Rule{}
    |> Rule.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a rule.

  ## Examples

      iex> update_rule(rule, %{field: new_value})
      {:ok, %Rule{}}

      iex> update_rule(rule, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_rule(%Rule{} = rule, attrs) do
    rule
    |> Rule.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a rule.

  ## Examples

      iex> delete_rule(rule)
      {:ok, %Rule{}}

      iex> delete_rule(rule)
      {:error, %Ecto.Changeset{}}

  """
  def delete_rule(%Rule{} = rule) do
    Repo.delete(rule)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking rule changes.

  ## Examples

      iex> change_rule(rule)
      %Ecto.Changeset{data: %Rule{}}

  """
  def change_rule(%Rule{} = rule, attrs \\ %{}) do
    Rule.changeset(rule, attrs)
  end

  # Condition functions

  @doc """
  Returns the list of conditions for a rule.

  ## Examples

      iex> list_conditions(rule_id)
      [%Condition{}, ...]

  """
  def list_conditions(rule_id) do
    Condition
    |> where([c], c.rule_id == ^rule_id)
    |> Repo.all()
  end

  @doc """
  Gets a single condition.

  Raises `Ecto.NoResultsError` if the Condition does not exist.

  ## Examples

      iex> get_condition!(123)
      %Condition{}

      iex> get_condition!(456)
      ** (Ecto.NoResultsError)

  """
  def get_condition!(id), do: Repo.get!(Condition, id)

  @doc """
  Creates a condition.

  ## Examples

      iex> create_condition(%{field: value})
      {:ok, %Condition{}}

      iex> create_condition(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_condition(attrs \\ %{}) do
    %Condition{}
    |> Condition.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a condition.

  ## Examples

      iex> update_condition(condition, %{field: new_value})
      {:ok, %Condition{}}

      iex> update_condition(condition, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_condition(%Condition{} = condition, attrs) do
    condition
    |> Condition.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a condition.

  ## Examples

      iex> delete_condition(condition)
      {:ok, %Condition{}}

      iex> delete_condition(condition)
      {:error, %Ecto.Changeset{}}

  """
  def delete_condition(%Condition{} = condition) do
    Repo.delete(condition)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking condition changes.

  ## Examples

      iex> change_condition(condition)
      %Ecto.Changeset{data: %Condition{}}

  """
  def change_condition(%Condition{} = condition, attrs \\ %{}) do
    Condition.changeset(condition, attrs)
  end

  # Feature evaluation

  @doc """
  Evaluates a feature flag for the given context.

  ## Examples

      iex> evaluate_feature("my-project", "my-feature", %{userId: "123", country: "KR"})
      {:ok, true}

      iex> evaluate_feature("non-existent", "my-feature", %{})
      {:error, :project_not_found}

      iex> evaluate_feature("my-project", "non-existent", %{})
      {:error, :feature_not_found}
  """
  def evaluate_feature(project_key, feature_key, context) do
    with %Project{} = project <- get_project_by_key(project_key),
         %Feature{} = feature <- get_feature_by_key(project.id, feature_key) do

      if not feature.is_active do
        {:ok, feature.default_variation}
      else
        rules = list_rules(feature.id)

        # Find the first matching rule
        matching_rule = Enum.find(rules, fn rule ->
          rule.is_active && rule_matches?(rule, context)
        end)

        # Return the variation from the matching rule or the default variation
        if matching_rule do
          {:ok, matching_rule.variation}
        else
          {:ok, feature.default_variation}
        end
      end
    else
      nil ->
        case get_project_by_key(project_key) do
          nil -> {:error, :project_not_found}
          _ -> {:error, :feature_not_found}
        end
    end
  end

  defp rule_matches?(rule, context) do
    conditions = list_conditions(rule.id)

    # All conditions must match for the rule to match
    Enum.all?(conditions, fn condition ->
      condition_matches?(condition, context)
    end)
  end

  defp condition_matches?(condition, context) do
    context_value = Map.get(context, condition.key)

    case condition.operator do
      "equals" ->
        context_value == condition.value

      "not_equals" ->
        context_value != condition.value

      "in" ->
        context_value in condition.values

      "not_in" ->
        context_value not in condition.values

      "contains" ->
        is_binary(context_value) && String.contains?(context_value, condition.value)

      "greater_than" ->
        case {context_value, condition.value} do
          {a, b} when is_number(a) and is_binary(b) ->
            case Float.parse(b) do
              {num, _} -> a > num
              :error -> false
            end
          {a, b} when is_binary(a) and is_binary(b) ->
            case {Float.parse(a), Float.parse(b)} do
              {{a_num, _}, {b_num, _}} -> a_num > b_num
              _ -> false
            end
          _ -> false
        end

      "less_than" ->
        case {context_value, condition.value} do
          {a, b} when is_number(a) and is_binary(b) ->
            case Float.parse(b) do
              {num, _} -> a < num
              :error -> false
            end
          {a, b} when is_binary(a) and is_binary(b) ->
            case {Float.parse(a), Float.parse(b)} do
              {{a_num, _}, {b_num, _}} -> a_num < b_num
              _ -> false
            end
          _ -> false
        end

      _ -> false
    end
  end
end
