defmodule GitIssues.Contributors do
  @moduledoc """
  This module provides functions to interact with GitHub contributors.
  """

  require Logger

  @type t :: %{username: String.t(), contributions: String.t()}

  @doc """
  Get a list of contributors for a given repository.

  ## Examples

      iex> GitIssues.Contributors.get("elixir-lang", "elixir")
      {:ok, []}
  """

  @spec get(String.t(), String.t()) ::
          {:ok, list(t())} | {:error, String.t()}
  def get(username, repo) do
    Logger.info("Fetching contributors for #{username}/#{repo}")

    github_client().get("/repos/#{username}/#{repo}/contributors")
    |> handle_response()
  end

  defp handle_response({:ok, %{status_code: code, body: contributors}})
       when code >= 200 and code < 300 do
    process_contributors(contributors)
  end

  defp handle_response({:ok, %{status_code: _, body: error}}), do: {:error, error}

  defp handle_response({:error, %{reason: reason}}), do: {:error, reason}

  defp process_contributors(contributors, result \\ [])
  defp process_contributors([], result), do: {:ok, result}

  defp process_contributors([contributor | rest], result) do
    result =
      result ++ [%{username: contributor["login"], contributions: contributor["contributions"]}]

    process_contributors(rest, result)
  end

  defp github_client, do: Application.get_env(:git_issues, :github)[:client]
end
