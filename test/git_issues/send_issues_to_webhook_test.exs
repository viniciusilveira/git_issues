defmodule GitIssues.SendIssuesToWebhookTest do
  use ExUnit.Case, async: false

  test "sends issues to webhook" do
    issue_created_at =
      DateTime.utc_now()
      |> DateTime.add(-24, :hour)

    issue = %{id: 1, created_at: issue_created_at, other_fields: "value"}
    true = :ets.insert(:issues, {1, issue})

    :ok = GitIssues.SendIssuesToWebhook.call()

    assert :ets.lookup(:issues, 1) == []
  end
end
