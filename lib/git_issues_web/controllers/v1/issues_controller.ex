defmodule GitIssuesWeb.V1.IssuesController do
  use GitIssuesWeb, :controller

  alias GitIssues.GetIssues

  def collect(conn, %{"username" => username, "repo" => repo}) do
    spawn(fn -> GetIssues.call(username, repo) end)
    send_resp(conn, 204, "")
  end

  def collect(conn, _params) do
    conn
    |> put_status(400)
    |> put_view(GitIssuesWeb.ErrorJSON)
    |> render("error.json", %{})
  end
end
