defmodule ExMdBlog.WebServer.Controller do
  @moduledoc """
  Controller.
  """

  require Logger
  alias ExMdBlog.Posts

  @doc "Gets a single post by id"
  def get_post(_req, %{bindings: %{id: id}}) do
    Logger.info("Fetching post with id: #{id}")

    case Posts.fetch(id) do
      {:ok, post} ->
        Logger.info("Post found and is being rendered")
        {200, Posts.to_html(post)}

      _ ->
        Logger.warning("Post not found")
        {404, "Post not found"}
    end
  end
end
