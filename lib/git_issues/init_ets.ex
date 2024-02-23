defmodule GitIssues.InitETS do
  @moduledoc """
  This module is responsible for initializing the ETS tables.
  """

  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    :ets.new(:issues, [:named_table, :set, :public])

    {:ok, []}
  end
end
