defmodule GitIssues.Github.ApiTest do
  use GitIssuesWeb.ConnCase, async: true

  alias GitIssues.Github.Api

  describe "process_response_body/1" do
    test "when body is valid, it returns the parsed body" do
      body = "{\"body\": \"body\"}"
      assert Api.process_response_body(body) == %{"body" => "body"}
    end
  end

  describe "process_request_body/1" do
    test "when body is valid, return body parsed" do
      body = %{"body" => "body"}
      assert Api.process_request_body(body) == "{\"body\":\"body\"}"
    end

    test "when an empty body is valid, return body parsed" do
      assert Api.process_request_body("") == ""
    end

    test "when body is nil, return body parsed" do
      assert Api.process_request_body(nil) == ""
    end
  end

  describe "process_request_url/1" do
    test "when url is valid, return url with api address" do
      url = "/url"
      IO.puts(base_url())
      assert Api.process_request_url(url) == base_url() <> url
    end
  end

  describe "process_request_headers/1" do
    test "when headers is valid, return headers with api headers" do
      headers = [{"header", "header"}]

      assert Api.process_request_headers(headers) == api_headers() ++ headers
    end
  end

  defp api_headers do
    [
      {"access_token", api_key()},
      {"Content-Type", "application/json"}
    ]
  end

  defp base_url do
    Application.get_env(:git_issues, :github)[:base_url]
  end

  defp api_key do
    Application.get_env(:git_issues, :github)[:api_key]
  end
end
