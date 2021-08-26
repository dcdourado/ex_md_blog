defmodule AuthBlog.WebServer.Controller do
  @moduledoc """
  Controller.
  """

  alias AuthBlog.Blog
  alias AuthBlog.Blog.Post

  alias Ecto.Changeset

  @doc "Lists posts"
  @spec posts_index(req :: term(), params :: map()) :: {:ok, list(Post.t())}
  def posts_index(_req, _params) do
    case Blog.list_post() do
      {:ok, result} -> {200, %{result: result}}
      {:error, reason} -> {500, %{error: reason}}
    end
  end

  @doc "Inserts post"
  @spec posts_insert(req :: term(), params :: map()) ::
          {pos_integer(), %{result: map()} | %{error: term()}}
  def posts_insert(_req, params) do
    case Blog.insert_post(params.body) do
      {:ok, result} -> {200, %{result: result}}
      {:error, %Changeset{} = reason} -> {401, %{error: reason}}
      {:error, reason} -> {500, %{error: reason}}
    end
  end
end
