defmodule GitIssues.GetIssuesTest do
  use ExUnit.Case

  alias GitIssues.GetIssues

  describe "get_issues" do
    test "with success" do
      assert {:ok, result} = GetIssues.call("elixir-lang", "elixir")

      assert result == %{
               user: "elixir-lang",
               repository: "elixir",
               issues: [{"Fix bug in jaro_distance implementation", "josevalim", []}],
               contributors: [{"José Valim", "josevalim", 4292}]
             }
    end

    test "with failure" do
      assert {:error,
              %{
                "documentation_url" =>
                  "https://docs.github.com/rest/issues/issues#list-repository-issues",
                "message" => "Not Found"
              }} = GetIssues.call("elixir-lang", "elixir-foo")
    end
  end
end
