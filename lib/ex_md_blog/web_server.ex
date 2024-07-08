defmodule ExMdBlog.WebServer do
  @moduledoc """
  A WebServer over Cowboy.
  """

  use GenServer
  require Logger

  alias ExMdBlog.WebServer.Router

  @name :webserver

  # Api

  def start_link([port: port] = opts) when is_integer(port) do
    GenServer.start_link(__MODULE__, opts, name: @name)
  end

  # Callbacks functions

  @impl GenServer
  def init(port: port) do
    Logger.info("Starting web server on port #{port}")

    opts = %{env: %{dispatch: dispatch_config()}}

    {:ok, _} = :cowboy.start_clear(:http, [port: port], opts)
  end

  # Private functions

  defp dispatch_config do
    :cowboy_router.compile(Router.build())
  end
end
