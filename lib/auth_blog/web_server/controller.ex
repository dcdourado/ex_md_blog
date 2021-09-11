defmodule AuthBlog.WebServer.Controller do
  @moduledoc """
  Controller.
  """

  alias AuthBlog.Blog
  alias AuthBlog.Blog.Post

  alias Ecto.Changeset

  @doc "Lists posts"
  @spec posts_index(req :: term(), params :: map()) ::
          {status_code :: pos_integer(), {:ok, list(Post.t())}}
  def posts_index(_req, _params) do
    case Blog.list_post() do
      {:ok, result} -> {200, %{result: result}}
      {:error, reason} -> {500, %{error: reason}}
    end
  end

  @doc "Inserts post"
  @spec posts_insert(req :: term(), params :: map()) ::
          {status_code :: pos_integer(), %{result: map()} | %{error: term()}}
  def posts_insert(_req, params) do
    case Blog.insert_post(params.body) do
      {:ok, result} -> {200, %{result: result}}
      {:error, %Changeset{} = reason} -> {401, %{error: reason}}
      {:error, reason} -> {500, %{error: reason}}
    end
  end

  @doc "Updates post"
  @spec posts_update(req :: term(), params :: map()) ::
          {status_code :: pos_integer(), %{result: map()} | %{error: term()}}
  def posts_update(_req, %{bindings: bindings, body: body} = _params) do
    with {:ok, post} <- Blog.fetch_post(id: bindings.id),
         {:ok, result} <- Blog.update_post(post, body) do
      {200, %{result: result}}
    else
      {:error, %Changeset{} = reason} -> {401, %{error: reason}}
      {:error, :not_found = reason} -> {404, %{error: reason}}
      {:error, reason} -> {500, %{error: reason}}
    end
  end

  @doc "Soft deletes a post"
  @spec posts_delete(req :: term(), params :: map()) ::
          {status_code :: pos_integer(), %{} | %{error: term()}}
  def posts_delete(_req, %{bindings: bindings} = _params) do
    with {:ok, post} <- Blog.fetch_post(id: bindings.id),
         :ok <- Blog.delete_post(post) do
      {204, nil}
    else
      {:error, :not_found = reason} -> {404, %{error: reason}}
      {:error, reason} -> {500, %{error: reason}}
    end
  end
end
