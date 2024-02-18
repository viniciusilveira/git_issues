defmodule GitIssues.GetIssues do
  @moduledoc """
  This module is responsible for getting the issues and contributors of a given repository.
  """

  alias GitIssues.Contributors
  alias GitIssues.Issues
  alias GitIssues.Users

  @doc """
  This function is responsible for getting the issues and contributors of a given repository.
  It receives the username and the repository name and returns a map with the user, repository, issues and contributors.

  ## Examples

      iex> GitIssues.GetIssues.call("elixir-lang", "elixir")
      {:ok, %{user: "elixir-lang", repository: "elixir", issues: [{"Fix bug in jaro_distance implementation", "josevalim", []}, ...], contributors: {"josevalim", "José Valim", "400"}, ...]}}
  """
  def call(username, repo) do
    with {:ok, issues} <- Issues.get(username, repo),
         {:ok, contributors} = Contributors.get(username, repo) do
      issues = %{
        user: username,
        repository: repo,
        issues: issues,
        contributors: Enum.map(contributors, &{get_user(elem(&1, 0)), elem(&1, 0), elem(&1, 1)})
      }

      true = :ets.insert(:issues, {DateTime.utc_now(), issues})

      {:ok, issues}
    end
  end

  defp get_user(login) do
    with {:ok, user} <- Users.get(login) do
      user
    end
  end
end
