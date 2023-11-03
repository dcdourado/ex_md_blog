defmodule ExMdBlog.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: ExMdBlog.Repo

  alias ExMdBlog.Posts.Post

  def post_factory do
    %Post{
      title: "Title",
      content: "__Content__"
    }
  end
end
