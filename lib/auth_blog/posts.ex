defmodule AuthBlog.Posts do
  @moduledoc """
  Post commands.
  """

  alias AuthBlog.Posts.Post
  alias AuthBlog.{Markdown, Repo}

  alias Ecto.Changeset

  @doc "Fetches a post"
  @spec fetch(filters :: Keyword.t()) ::
          {:ok, Post.t()} | {:error, :not_found | :too_many_results}
  def fetch(filters) when is_list(filters) do
    case Repo.get_by(Post, filters) do
      nil -> {:error, :not_found}
      post -> {:ok, post}
    end
  rescue
    Ecto.MultipleResultsError -> {:error, :too_many_results}
  end

  @doc "Lists posts"
  @spec list() :: {:ok, list(Post.t())}
  def list do
    {:ok, Repo.all(Post)}
  end

  @doc "Inserts a post"
  @spec insert(params :: map()) :: {:ok, Post.t()} | {:error, Changeset.t()}
  def insert(params) when is_map(params) do
    params
    |> Post.changeset()
    |> Repo.insert()
  end

  @doc "Updates a post"
  @spec update(post :: Post.t(), params :: map()) ::
          {:ok, Post.t()} | {:error, Changeset.t()}
  def update(%Post{} = post, params) when is_map(params) do
    post
    |> Post.changeset(params)
    |> Repo.update()
  end

  @doc "Soft deletes a post"
  @spec delete(post :: Post.t()) :: :ok | {:error, Changeset.t() | :already_deleted}
  def delete(%Post{} = post) do
    post
    |> Post.changeset(%{deleted_at: NaiveDateTime.utc_now()})
    |> Repo.update()
    |> case do
      {:ok, _} -> :ok
      error -> error
    end
  end

  @doc "Wraps a post on HTML string"
  @spec to_html(post :: Post.t()) :: String.t()
  def to_html(%Post{} = post) do
    """
    # #{post.title}
    ## #{post.description}
    #{post.content}
    """
    |> Markdown.render()
  end
end
