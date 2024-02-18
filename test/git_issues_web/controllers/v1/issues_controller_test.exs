defmodule GitIssues.V1.IssuesControllerTest do
  use GitIssuesWeb.ConnCase

  describe "GET /git-issues/api/v1/issues?username=&repo=" do
    test " with success", %{conn: conn} do
      conn = get(conn, "/git-issues/api/v1/issues?username=elixir-lang&repo=elixir")

      assert conn.status == 204
    end

    test "with failure when username is not provided", %{conn: conn} do
      conn = get(conn, "/git-issues/api/v1/issues?repo=elixir")

      assert conn.status == 400
      assert json_response(conn, 400) == %{"errors" => %{"detail" => "Internal Server Error"}}
    end
  end
end
