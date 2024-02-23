defmodule GitIssues.GetIssuesTest do
  use ExUnit.Case, async: true

  alias GitIssues.GetIssues

  describe "call/2" do
    setup do
      :ets.delete_all_objects(:issues)
      on_exit(fn -> :ets.delete_all_objects(:issues) end)

      %{}
    end

    test "with success" do
      assert {:ok, result} = GetIssues.call("elixir-lang", "elixir")

      assert %{
               contributors: [%{contributions: 4292, username: "josevalim", namme: "José Valim"}],
               created_at: _,
               issues: [
                 %{
                   labels: [],
                   title: "Fix bug in jaro_distance implementation",
                   username: "josevalim"
                 }
               ],
               repository: "elixir",
               user: "elixir-lang"
             } = result

      [{_, issue}] = :ets.tab2list(:issues)

      assert issue == result
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
