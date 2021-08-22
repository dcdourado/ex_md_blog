defmodule AuthBlog.WebServer.Router do
  @moduledoc """
  Defines routes and links them to `AuthBlog.WebServer.Controller` by method.

  Configuration example:
    {"/path", method: handler}
  """

  alias AuthBlog.WebServer.Controller
  alias AuthBlog.WebServer.RESTHandler

  @namespace "/api/v1"

  @routes [
    {"/posts", get: &Controller.posts_index/2}
  ]

  @doc "Builds routing list for cowboy"
  @spec build() :: list({route :: String.t(), conn_handler :: module(), path_handler :: fun()})
  def build do
    [
      {:_,
       @routes
       |> Enum.map(fn {path, path_handlers} ->
         {@namespace <> path, RESTHandler, path_handlers}
       end)
       |> Enum.concat([
         {"/", :cowboy_static, {:file, "assets/homepage.html"}},
         {"/[...]", RESTHandler, nil}
       ])}
    ]
  end
end
