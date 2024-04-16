defmodule ExMdBlog.Repo.StaticFileRepoAdapter do
  @moduledoc """
  A Repo adapter that uses static files as a data source.
  """

  @behaviour ExMdBlog.Repo

  @posts_path "/priv/posts/"

  require Logger
  alias ExMdBlog.Posts.Post

  @impl true
  def fetch(id) do
    posts_full_path = Application.app_dir(:ex_md_blog) <> @posts_path <> "#{id}.md"

    case File.read(posts_full_path) do
      {:ok, content} -> {:ok, build_post(id, content)}
      {:error, :enoent} -> {:error, :not_found}
    end
  end

  defp build_post(id, content) do
    title =
      content
      |> String.split("\n")
      |> Enum.find(&String.starts_with?(&1, "#"))
      |> String.replace("#", "")
      |> String.trim()

    content =
      content
      |> String.split("\n")
      |> Enum.drop(1)
      |> Enum.join("\n")

    %Post{id: id, title: title, content: content}
  end
end
