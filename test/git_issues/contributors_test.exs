defmodule GitIssues.ContributorsTest do
  use ExUnit.Case, async: true

  alias GitIssues.Contributors

  describe "get/2" do
    test "with success when the repository exists and the user is valid" do
      assert {:ok, contributors} = Contributors.get("elixir-lang", "elixir")

      assert contributors == [%{contributions: 4292, username: "josevalim"}]
    end

    test "with error when the repository does not exist" do
      error =
        """
        {
        "message": "Not Found",
        "documentation_url": "https://docs.github.com/rest/repos/repos#list-repository-contributors"
        }
        """
        |> Jason.decode!()

      assert {:error, error} == Contributors.get("elixir-lang", "elixir-foo")
    end
  end
end
