defmodule ExMdBlog.WebServer.Router do
  @moduledoc """
  Defines routes and links them to `ExMdBlog.WebServer.Controller` by method.

  Configuration example:
    {"/path", method: handler}
  """

  alias ExMdBlog.WebServer.{Controller, RESTHandler}

  @routes [
    {"/posts/:id", get: &Controller.get_post/2}
  ]

  @doc "Builds routing list for cowboy"
  @spec build(html_path :: String.t()) ::
          list({route :: String.t(), conn_handler :: module(), path_handler :: fun()})
  def build(html_path) do
    [
      {:_,
       @routes
       |> Enum.map(fn {path, path_handlers} ->
         {path, RESTHandler, path_handlers}
       end)
       |> Enum.concat([
         {"/", :cowboy_static, {:file, html_path}},
         {"/assets/[...]", :cowboy_static, {:priv_dir, :ex_md_blog, "assets"}},
         {"/[...]", RESTHandler, nil}
       ])}
    ]
  end
end
