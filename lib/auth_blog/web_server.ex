defmodule AuthBlog.WebServer do
  @moduledoc """
  A WebServer over Cowboy.
  """

  use GenServer

  alias AuthBlog.WebServer.Router

  @name :webserver

  # Api

  def start_link([port: port] = opts) when is_integer(port) do
    GenServer.start_link(__MODULE__, opts, name: @name)
  end

  # Callbacks functions

  @impl GenServer
  def init(port: port) do
    {:ok, _} = :cowboy.start_clear(:http, [port: port], %{env: %{dispatch: dispatch_config()}})
  end

  # Private functions

  defp dispatch_config do
    :cowboy_router.compile(Router.build())
  end
end
