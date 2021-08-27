defmodule AuthBlog.Blog do
  @moduledoc """
  Blog commands.
  """

  alias AuthBlog.Blog.Post
  alias AuthBlog.Repo

  alias Ecto.Changeset

  @doc "Fetches a post"
  @spec fetch_post(filters :: Keyword.t()) ::
          {:ok, Post.t()} | {:error, :not_found | :too_many_results}
  def fetch_post(filters) when is_list(filters) do
    try do
      case Repo.get_by(Post, filters) do
        nil -> {:error, :not_found}
        post -> {:ok, post}
      end
    rescue
      Ecto.MultipleResultsError -> {:error, :too_many_results}
    end
  end

  @doc "Lists posts"
  @spec list_post() :: {:ok, list(Post.t())}
  def list_post do
    {:ok, Repo.all(Post)}
  end

  @doc "Inserts a post"
  @spec insert_post(params :: map()) :: {:ok, Post.t()} | {:error, Changeset.t()}
  def insert_post(params) when is_map(params) do
    params
    |> Post.changeset()
    |> Repo.insert()
  end

  @doc "Updates a post"
  @spec update_post(post :: Post.t(), params :: map()) ::
          {:ok, Post.t()} | {:error, Changeset.t()}
  def update_post(%Post{} = post, params) when is_map(params) do
    post
    |> Post.changeset(params)
    |> Repo.update()
  end

  @doc "Soft deletes a post"
  @spec delete_post(post :: Post.t()) :: :ok | {:error, Changeset.t() | :already_deleted}
  def delete_post(%Post{} = post) do
    post
    |> Post.changeset(%{deleted_at: NaiveDateTime.utc_now()})
    |> Repo.update()
    |> case do
      {:ok, _} -> :ok
      error -> error
    end
  end
end
