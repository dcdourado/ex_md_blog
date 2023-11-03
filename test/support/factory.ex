defmodule ExMdBlog.Factory do
  @moduledoc false

  alias ExMdBlog.Posts.Post

  def post_factory do
    %Post{
      title: "Title",
      content: "__Content__"
    }
  end
end
