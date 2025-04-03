defmodule OndinWeb.ProjectJSON do
  alias Ondin.FeatureFlags.Project

  @doc """
  Renders a list of projects.
  """
  def index(%{projects: projects}) do
    %{data: for(project <- projects, do: data(project))}
  end

  @doc """
  Renders a single project.
  """
  def show(%{project: project}) do
    %{data: data(project)}
  end

  defp data(%Project{} = project) do
    %{
      id: project.id,
      name: project.name,
      key: project.key,
      description: project.description,
      is_active: project.is_active,
      inserted_at: project.inserted_at,
      updated_at: project.updated_at
    }
  end
end
