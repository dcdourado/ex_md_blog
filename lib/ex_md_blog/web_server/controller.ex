defmodule ExMdBlog.WebServer.Controller do
  @moduledoc """
  Controller.
  """

  alias ExMdBlog.Posts

  @doc "Lists posts"
  def posts_index(_req, _params) do
    case Posts.list() do
      {:ok, result} -> {200, %{result: result}}
      {:error, reason} -> {500, %{error: reason}}
    end
  end
end
