defmodule GitIssues.Mock.Github.WebhookClient do
  @moduledoc false

  use GitIssues.Services, :behaviour

  def post!(_, _, _) do
    {:ok,
     %{
       status_code: 200,
       body: ""
     }}
  end
end
