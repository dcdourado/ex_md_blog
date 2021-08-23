defmodule AuthBlog.WebServer.Controller do
  @moduledoc """
  Controller.
  """

  alias AuthBlog.Blog

  @doc "Lists posts"
  @spec posts_index(req :: term(), params :: map()) :: {:ok, list(map())} | {:error, atom()}
  def posts_index(_req, _params) do
    case Blog.list_post() do
      {:ok, result} -> {200, %{result: result}}
      {:error, reason} -> {500, %{error: reason}}
    end
  end
end
