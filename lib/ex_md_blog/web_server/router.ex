defmodule ExMdBlog.WebServer.Router do
  @moduledoc """
  Defines routes and links them to `ExMdBlog.WebServer.Controller` by method.

  Configuration example:
    {"/path", method: handler}
  """

  alias ExMdBlog.WebServer.{Controller, RESTHandler}

  @namespace "/api/v1"

  @routes [
    {"/posts", get: &Controller.posts_index/2, post: &Controller.posts_insert/2},
    {"/posts/:id", put: &Controller.posts_update/2, delete: &Controller.posts_delete/2}
  ]

  @doc "Builds routing list for cowboy"
  @spec build(html_path :: String.t()) ::
          list({route :: String.t(), conn_handler :: module(), path_handler :: fun()})
  def build(html_path) do
    [
      {:_,
       @routes
       |> Enum.map(fn {path, path_handlers} ->
         {@namespace <> path, RESTHandler, path_handlers}
       end)
       |> Enum.concat([
         {"/", :cowboy_static, {:file, html_path}},
         {"/[...]", RESTHandler, nil}
       ])}
    ]
  end
end
