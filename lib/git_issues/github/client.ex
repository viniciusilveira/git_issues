defmodule GitIssues.Github.Client do
  @moduledoc """
  Serviço responsável pela comunicação com API do  github
  """
  use GitIssues.Services, :behaviour

  @impl true
  def default_headers, do: [{"access_token", api_key()}, {"Content-Type", "application/json"}]

  @impl true
  def base_url, do: Application.get_env(:git_issues, :github)[:base_url]

  @impl true
  def process_response_body(body), do: Jason.decode!(body)

  defp api_key do
    Application.get_env(:git_issues, :github)[:api_key]
  end
end
