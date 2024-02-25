defmodule GitIssues.GetIssues do
  @moduledoc """
  This module is responsible for getting the issues and contributors of a given repository.
  """

  require Logger

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
  @spec call(String.t(), String.t()) ::
          {:ok,
           %{
             user: String.t(),
             repository: String.t(),
             issues: list(Issues.t()),
             contributors: list(Contributors.t())
           }}
  def call(username, repo) do
    fetch_issues_task = Task.async(fn -> Issues.get(username, repo) end)
    fetch_contributors_task = Task.async(fn -> Contributors.get(username, repo) end)

    with {:ok, issues} <- Task.await(fetch_issues_task),
         {:ok, contributors} <- Task.await(fetch_contributors_task) do
      issues = %{
        user: username,
        repository: repo,
        created_at: DateTime.utc_now(),
        issues: issues,
        contributors:
          Enum.map(
            contributors,
            &%{
              namme: get_user(&1.username),
              username: &1.username,
              contributions: &1.contributions
            }
          )
      }

      true = :ets.insert(:issues, {UUID.uuid4(), issues})

      Logger.info(
        "Issues and contributors of #{username}/#{repo} have been successfully fetched."
      )

      {:ok, issues}
    end
  end

  defp get_user(login) do
    with {:ok, user} <- Users.get(login) do
      user
    end
  end
end
