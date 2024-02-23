defmodule GitIssues.SendIssuesToWebhook do
  @moduledoc """
  This module is responsible for sending issues storaged in ETS to a webhook 24 hours after collect.
  """

  require Logger

  @doc """
  Sends the issues to the webhook.

  ## Examples

      iex> GitIssues.SendIssuesToWebhook.call()
      :ok
  """
  def call do
    IO.puts("Sending issues to webhook")

    :issues
    |> :ets.tab2list()
    |> Enum.each(fn {id, issue} ->
      if DateTime.diff(DateTime.utc_now(), issue.created_at, :hour) == delay_to_send_issue() do
        Logger.info("Issue #{id} created at #{issue.created_at} is ready to be sent to webhook")
        spawn(fn -> send_issue(issue) end)
        :ets.delete(:issues, id)
      end
    end)

    :ok
  end

  defp send_issue(issue) do
    IO.puts("Sending issue to webhook ")

    body = Jason.encode!(issue)

    webhook_url()
    |> webhook_client().post!(body, [])
  end

  defp delay_to_send_issue, do: Application.get_env(:git_issues, :github)[:delay]

  defp webhook_url, do: Application.get_env(:git_issues, :github)[:webhook_url]
  defp webhook_client, do: Application.get_env(:git_issues, :github)[:webhook_client]
end
