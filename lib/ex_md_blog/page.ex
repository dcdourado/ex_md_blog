defmodule ExMdBlog.Page do
  @moduledoc """
  Blog page domain functions.
  """

  require Logger
  alias ExMdBlog.Posts

  @pages_path "/priv/pages/"
  @base_path @pages_path <> "base.html.eex"
  @home_path @pages_path <> "home.html.eex"

  @doc "Renders home page and writes HTML file on pages folder"
  @spec render_home() :: path :: String.t()
  def render_home do
    home_full_path = Application.app_dir(:ex_md_blog) <> @home_path
    home_html = EEx.eval_file(home_full_path, post_callouts: render_post_callouts())

    base_full_path = Application.app_dir(:ex_md_blog) <> @base_path
    full_html = EEx.eval_file(base_full_path, content: home_html)

    # removing .eex of the original path
    output_path = String.slice(home_full_path, 0, String.length(home_full_path) - 4)

    :ok = write_file(output_path, full_html)
    output_path
  end

  defp render_post_callouts do
    Posts.list()
    |> Stream.map(&Posts.to_callout_html/1)
    |> Enum.join("\n")
  end

  @doc "Renders a list of post pages, writing them down in HTML on pages folder"
  @spec render_posts() :: list({id :: String.t(), path :: String.t()})
  def render_posts do
    Enum.map(Posts.list(), fn post ->
      post_path = @pages_path <> post.id <> ".html"
      post_full_path = Application.app_dir(:ex_md_blog) <> post_path
      post_html = Posts.to_html(post)

      base_full_path = Application.app_dir(:ex_md_blog) <> @base_path
      full_html = EEx.eval_file(base_full_path, content: post_html)

      :ok = write_file(post_full_path, full_html)
      {post.id, post_full_path}
    end)
  end

  defp write_file(output_path, full_html) do
    case File.write(output_path, full_html) do
      :ok ->
        Logger.info("HTML file written to #{output_path}")

      err ->
        Logger.error("Error writing HTML file: #{inspect(err)}")
        err
    end
  end
end
