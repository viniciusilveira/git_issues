defmodule GitIssues.V1.IssuesControllerTest do
  use GitIssuesWeb.ConnCase, async: true

  describe "GET /git-issues/api/v1/issues?username=&repo=" do
    test " with success", %{conn: conn} do
      conn = get(conn, "/git-issues/api/issues?username=elixir-lang&repo=elixir")

      assert conn.status == 204
    end
  end
end
