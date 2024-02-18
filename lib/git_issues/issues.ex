defmodule GitIssues.Issues do
  @moduledoc """
  This module provides functions to interact with GitHub issues.
  """

  @doc """
  Get a list of issues for a given repository.

  ## Examples

      iex> GitIssues.Issues.get("elixir-lang", "elixir")
      {:ok, []}
  """
  @spec get(String.t(), String.t()) ::
          {:ok, list({String.t(), String.t(), String.t()})} | {:error, String.t()}
  def get(username, repo) do
    github_client().get("/repos/#{username}/#{repo}/issues")
    |> handle_response()
  end

  defp handle_response({:ok, %{status_code: code, body: issues}})
       when code >= 200 and code < 300 do
    process_issues(issues)
  end

  defp handle_response({:ok, %{status_code: _, body: error}}), do: {:error, error}

  defp handle_response({:error, %{reason: reason}}), do: {:error, reason}

  defp process_issues(issues, result \\ [])
  defp process_issues([], result), do: {:ok, result}

  defp process_issues([issue | rest], result) do
    result = result ++ [{issue["title"], issue["user"]["login"], issue["labels"]}]
    process_issues(rest, result)
  end

  defp github_client, do: Application.get_env(:git_issues, :github)[:client]
end
