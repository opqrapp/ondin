defmodule OndinWeb.ProjectController do
  use OndinWeb, :controller

  alias Ondin.FeatureFlags
  alias Ondin.FeatureFlags.Project

  action_fallback OndinWeb.FallbackController

  def index(conn, _params) do
    projects = FeatureFlags.list_projects()
    render(conn, :index, projects: projects)
  end

  def create(conn, %{"project" => project_params}) do
    with {:ok, %Project{} = project} <- FeatureFlags.create_project(project_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/projects/#{project}")
      |> render(:show, project: project)
    end
  end

  def show(conn, %{"id" => id}) do
    project = FeatureFlags.get_project!(id)
    render(conn, :show, project: project)
  end

  def update(conn, %{"id" => id, "project" => project_params}) do
    project = FeatureFlags.get_project!(id)

    with {:ok, %Project{} = project} <- FeatureFlags.update_project(project, project_params) do
      render(conn, :show, project: project)
    end
  end

  def delete(conn, %{"id" => id}) do
    project = FeatureFlags.get_project!(id)

    with {:ok, %Project{}} <- FeatureFlags.delete_project(project) do
      send_resp(conn, :no_content, "")
    end
  end
end
