defmodule GitIssues.Github.WebhookClient do
  @moduledoc """
  Serviço responsável pela comunicação com API do  github
  """
  use GitIssues.Services, :behaviour

  @impl true
  def default_headers,
    do: [{"Content-Type", "application/json"}]

  @impl true

  def process_response_body(body) when is_binary(body), do: body
end
