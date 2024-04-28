defmodule ExMdBlog.WebServer.Router do
  @moduledoc """
  Defines routes and links them to `ExMdBlog.WebServer.Controller` by method.
  """

  alias ExMdBlog.Page

  @doc "Builds routing list for cowboy"
  @spec build() :: routes :: list({:_, any()})
  def build do
    home_path = Page.render_home()
    posts_path = Page.render_posts()
    post_id_paths = Page.render_all_posts()

    all_post_routes =
      Enum.map(post_id_paths, fn {id, post_path} ->
        {"/posts/#{id}", :cowboy_static, {:file, post_path}}
      end)

    [
      {:_,
       [
         {"/", :cowboy_static, {:file, home_path}},
         {"/posts", :cowboy_static, {:file, posts_path}},
         {"/assets/[...]", :cowboy_static, {:priv_dir, :ex_md_blog, "assets"}}
         | all_post_routes
       ]}
    ]
  end
end
