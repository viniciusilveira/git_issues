defmodule GitIssues.IssuesTest do
  use ExUnit.Case, async: true

  alias GitIssues.Issues

  describe "get/2" do
    test "with success when the repository exists and the user is valid" do
      assert {:ok, issues} = Issues.get("elixir-lang", "elixir")

      assert issues ==
               "test/support/fixtures/github/elixir_lang_issues.json"
               |> File.read!()
               |> Jason.decode!()
    end

    test "with error when the repository does not exist" do
      error =
        """
        {
        "message": "Not Found",
        "documentation_url": "https://docs.github.com/rest/issues/issues#list-repository-issues"
        }
        """
        |> Jason.decode!()

      assert {:error, error} == Issues.get("elixir-lang", "elixir-foo")
    end
  end
end
