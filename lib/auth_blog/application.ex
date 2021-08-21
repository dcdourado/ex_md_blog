defmodule AuthBlog.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {AuthBlog.WebServer, []}
    ]

    opts = [strategy: :one_for_one, name: AuthBlog.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
