defmodule GitIssues.Github.WebhookClient do
  @moduledoc """
  Serviço responsável pela comunicação com API do  github
  """
  use GitIssues.Services, :behaviour

  @impl true
  def default_headers,
    do: [{"Content-Type", "application/json"}]

  @impl true
  def base_url, do: Application.get_env(:git_issues, :github)[:webhook_url]

  @impl true
  def process_response_body(body), do: Jason.decode!(body)
end
