defmodule ExMdBlog.Application do
  @moduledoc false

  use Application

  @port 8080

  @impl true
  def start(_type, _args) do

    children = [
      {ExMdBlog.WebServer, [port: @port]},
      {Goth, name: ExMdBlog.Goth}
    ]

    opts = [strategy: :one_for_one, name: ExMdBlog.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
