defmodule ExMdBlog.WebServer do
  @moduledoc """
  A WebServer over Cowboy.
  """

  use GenServer
  require Logger

  alias ExMdBlog.Page
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
    {:ok, html_path} = Page.render(1)

    {:ok, _} =
      :cowboy.start_clear(:http, [port: port], %{env: %{dispatch: dispatch_config(html_path)}})
  end

  # Private functions

  defp dispatch_config(html_path) do
    :cowboy_router.compile(Router.build(html_path))
  end
end
