defmodule AuthBlog.Blog do
  @moduledoc """
  Blog commands.
  """

  alias AuthBlog.Blog.Post
  alias AuthBlog.Repo

  alias Ecto.Changeset

  @doc "Inserts a post"
  @spec insert_post(params :: map()) :: {:ok, Post.t()} | {:error, Changeset.t()}
  def insert_post(params) when is_map(params) do
    params
    |> Post.changeset()
    |> Repo.insert()
  end

  @doc "Updates a post"
  @spec update_post(post :: Post.t(), params :: map()) :: {:ok, Post.t()} | {:error, Changeset.t()}
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
