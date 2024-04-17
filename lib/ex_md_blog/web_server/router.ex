defmodule ExMdBlog.WebServer.Router do
  @moduledoc """
  Defines routes and links them to `ExMdBlog.WebServer.Controller` by method.
  """

  @doc "Builds routing list for cowboy"
  @spec build(
          home_path :: String.t(),
          post_paths :: list({id :: String.t(), post_path :: String.t()})
        ) :: routes :: list({:_, any()})
  def build(home_path, post_paths) do
    post_routes =
      Enum.map(post_paths, fn {id, post_path} ->
        {"/posts/#{id}", :cowboy_static, {:file, post_path}}
      end)

    [
      {:_,
       post_routes ++
         [
           {"/", :cowboy_static, {:file, home_path}},
           {"/assets/[...]", :cowboy_static, {:priv_dir, :ex_md_blog, "assets"}}
         ]}
    ]
  end
end
