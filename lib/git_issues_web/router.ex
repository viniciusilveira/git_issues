defmodule GitIssuesWeb.Router do
  use GitIssuesWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/git-issues" do
    scope "/api", GitIssuesWeb do
      pipe_through :api

      scope "/v1", V1 do
        get "issues", IssuesController, :collect
      end
    end
  end

  # Enable Swoosh mailbox preview in development
  if Application.compile_env(:git_issues, :dev_routes) do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
