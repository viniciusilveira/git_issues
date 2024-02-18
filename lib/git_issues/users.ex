defmodule GitIssues.Users do
  @moduledoc """
  This module provides functions to interact with GitHub users.
  """

  @doc """
  Get a list of users for a given repository.

  ## Examples

      iex> GitIssues.Users.get("elixir-lang", "elixir")
      {:ok, []}
  """
  @spec get(String.t()) ::
          {:ok, String.t()} | {:error, String.t()}
  def get(username) do
    github_api().get("/users/#{username}")
    |> handle_response()
  end

  defp handle_response({:ok, %{status_code: code, body: user}})
       when code >= 200 and code < 300 do
    {:ok, user["name"]}
  end

  defp handle_response({:ok, %{status_code: _, body: error}}), do: {:error, error}

  defp handle_response({:error, %{reason: reason}}), do: {:error, reason}

  defp github_api, do: Application.get_env(:git_issues, :github)[:api]
end
