defmodule GitIssues.Issues do
  @doc """
  Get a list of issues for a given repository.

  ## Examples

      iex> GitIssues.Issues.get("elixir-lang", "elixir")
      {:ok, [
        %GitIssues.Issue{...},
        %GitIssues.Issue{...},
        ...
      ]}
  """
  @spec get(String.t(), String.t()) :: {:ok, list(GitIssues.Issue.t())} | {:error, String.t()}
  def get(username, repo) do
    github_api().get("/repos/#{username}/#{repo}/issues")
    |> handle_response()
  end

  def handle_response({:ok, %{status_code: code, body: body}})
      when code >= 200 and code < 300 do
    {:ok, body}
  end

  def handle_response({:ok, %{status_code: _, body: error}}), do: {:error, error}

  def handle_response({:error, %{reason: reason}}), do: {:error, reason}

  defp github_api, do: Application.get_env(:git_issues, :github)[:api]
end
