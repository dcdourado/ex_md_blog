defmodule AuthBlog.WebServer do
  @moduledoc """
  A webserver over :cowboy.
  """

  use GenServer

  alias AuthBlog.WebServer.Router

  @name __MODULE__
  @port 8080

  # Api

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: @name)
  end

  # Callbacks functions

  def init(_opts) do
    {:ok, _} = :cowboy.start_clear(:router, [port: @port], %{env: %{dispatch: dispatch_config()}})
  end

  # Private functions

  defp dispatch_config do
    :cowboy_router.compile([
      {:_, Router.build()}
    ])
  end
end
