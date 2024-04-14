defmodule ExMdBlog.Posts do
  @moduledoc """
  Post commands.
  """

  alias ExMdBlog.Posts.Post
  alias ExMdBlog.{Markdown, Repo}

  @doc "Fetches a post"
  defdelegate fetch(id), to: Repo

  @doc "Lists posts"
  @spec list() :: list(Post.t())
  def list do
    {:ok, first_post} =
      fetch("dependency-inversion-on-elixir-using-ports-and-adapters-design-pattern")

    {:ok, second_post} = fetch("understanding-genstage-back-pressure-mechanism")

    [first_post, second_post]
  end

  @doc "Wraps a post on HTML string"
  @spec to_html(post :: Post.t()) :: String.t()
  def to_html(%Post{} = post) do
    """
    # #{post.title}
    #{post.content}
    """
    |> Markdown.render()
    |> enclose_with("section")
  end

  def to_html([%Post{} | _] = posts) do
    posts
    |> Stream.map(&to_html/1)
    |> Enum.join("\n")
    |> enclose_with("main")
  end

  @doc "Wraps a post call-out on HTML string"
  @spec to_callout_html(post :: Post.t()) :: String.t()
  def to_callout_html(%Post{} = post) do
    """
    # #{post.title}
    Continue reading...
    """
    |> Markdown.render()
    |> enclose_with("section")
    |> link_to("/posts/#{post.id}")
  end

  defp enclose_with(content, tag), do: "<#{tag}>#{content}</#{tag}>"
  defp link_to(content, url), do: "<a href=\"#{url}\">#{content}</a>"
end
