defmodule ExMdBlog.Repo.StaticFileRepoAdapter do
  @moduledoc """
  A Repo adapter that uses static files as a data source.
  """

  @behaviour ExMdBlog.Repo

  @posts_path_prefix "lib/ex_md_blog/page/posts/"

  alias ExMdBlog.Posts.Post

  @impl true
  def fetch(id) do
    case File.read(@posts_path_prefix <> "#{id}.md") do
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
