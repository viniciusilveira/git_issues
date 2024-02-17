defmodule GitIssues.Mock.Github.Api do
  @moduledoc false

  use GitIssues.Services, :behaviour

  def get("/repos/elixir-lang/elixir/issues") do
    {:ok,
     %{
       status_code: 200,
       body:
         "test/support/fixtures/github/elixir_lang_issues.json" |> File.read!() |> Jason.decode!()
     }}
  end

  def get("/repos/elixir-lang/elixir-foo/issues") do
    body =
      """
      {
      "message": "Not Found",
      "documentation_url": "https://docs.github.com/rest/issues/issues#list-repository-issues"
      }
      """
      |> Jason.decode!()

    {:ok, %{status_code: 404, body: body}}
  end
end
