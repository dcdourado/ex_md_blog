defmodule ExMdBlog.Posts do
  @moduledoc """
  Post commands.
  """

  alias ExMdBlog.Markdown
  alias ExMdBlog.Posts.Post
  alias ExMdBlog.Repo.GoogleDriveRepoAdapter
  alias ExMdBlog.Repo.StaticFileRepoAdapter

  @doc "Lists posts"
  @spec list() :: list(Post.t())
  def list do
    GoogleDriveRepoAdapter.all() ++ StaticFileRepoAdapter.all()
  end

  @doc """
  Gets post content on HTML string.

  Whent content is nil, it loads the HTML directly from Drive repo.
  Else, it renders the content as markdown and encloses it with a section tag.
  """
  @spec to_html(post :: Post.t()) :: String.t()
  def to_html(%Post{content: nil} = post) do
    {:ok, html} = GoogleDriveRepoAdapter.fetch(post.id)
    html
  end

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
    ### #{post.title}
    Continue reading...
    """
    |> Markdown.render()
    |> enclose_with("section")
    |> link_to("/posts/#{post.id}")
  end

  defp enclose_with(content, tag), do: "<#{tag}>#{content}</#{tag}>"
  defp link_to(content, url), do: "<a href=\"#{url}\">#{content}</a>"
end
