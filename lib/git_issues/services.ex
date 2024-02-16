defmodule GitIssues.Services do
  @moduledoc """
  Módulo base de serviço para fazer chamadas à APIs.
  """

  @callback default_headers() :: list()

  @callback base_url() :: String.t()

  def behaviour do
    quote do
      use HTTPoison.Base

      @behaviour GitIssues.Services

      @impl true
      def process_request_url(path), do: base_url() <> path

      @impl true
      def process_request_body(body) when is_nil(body) or body == "", do: ""

      @impl true
      def process_request_body(body), do: Jason.encode!(body)

      @impl true
      def process_response_body(body) when is_nil(body) or body == "", do: ""

      @impl true
      def process_response_body(body), do: Jason.decode!(body)

      @impl true
      def process_request_headers(headers) when is_map(headers),
        do: default_headers() ++ Map.to_list(headers)

      @impl true
      def process_request_headers(headers), do: default_headers() ++ headers

      @impl true
      def default_headers, do: ["Content-Type": "application/json", Accept: "application/json"]

      @impl true
      def base_url, do: ""

      defp timeout, do: Application.get_env(:checkout_area, :client_timeout)

      defoverridable Module.definitions_in(__MODULE__)
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
