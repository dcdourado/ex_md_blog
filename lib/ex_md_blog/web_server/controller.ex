defmodule ExMdBlog.WebServer.Controller do
  @moduledoc """
  Controller.
  """

  alias ExMdBlog.Posts
  alias ExMdBlog.Posts.Post

  alias Ecto.Changeset

  @doc "Lists posts"
  @spec posts_index(req :: term(), params :: map()) ::
          {status_code :: pos_integer(), {:ok, list(Post.t())}}
  def posts_index(_req, _params) do
    case Posts.list() do
      {:ok, result} -> {200, %{result: result}}
      {:error, reason} -> {500, %{error: reason}}
    end
  end

  @doc "Inserts post"
  @spec posts_insert(req :: term(), params :: map()) ::
          {status_code :: pos_integer(), %{result: map()} | %{error: term()}}
  def posts_insert(_req, params) do
    case Posts.insert(params.body) do
      {:ok, result} -> {200, %{result: result}}
      {:error, %Changeset{} = reason} -> {401, %{error: reason}}
      {:error, reason} -> {500, %{error: reason}}
    end
  end

  @doc "Updates post"
  @spec posts_update(req :: term(), params :: map()) ::
          {status_code :: pos_integer(), %{result: map()} | %{error: term()}}
  def posts_update(_req, %{bindings: bindings, body: body} = _params) do
    with {:ok, post} <- Posts.fetch(id: bindings.id),
         {:ok, result} <- Posts.update(post, body) do
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
    with {:ok, post} <- Posts.fetch(id: bindings.id),
         :ok <- Posts.delete(post) do
      {204, nil}
    else
      {:error, :not_found = reason} -> {404, %{error: reason}}
      {:error, reason} -> {500, %{error: reason}}
    end
  end
end
