defmodule GitIssuesWeb.V1.IssuesController do
  use GitIssuesWeb, :controller

  def collect(conn, %{"username" => _username, "repo" => _repo}) do
    send_resp(conn, 204, "")
  end
end
