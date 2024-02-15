defmodule GitIssues.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      GitIssuesWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:git_issues, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: GitIssues.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: GitIssues.Finch},
      # Start a worker by calling: GitIssues.Worker.start_link(arg)
      # {GitIssues.Worker, arg},
      # Start to serve requests, typically the last entry
      GitIssuesWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GitIssues.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GitIssuesWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
