defmodule AuthBlog.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: AuthBlog.Repo

  alias AuthBlog.Posts.Post

  def post_factory do
    %Post{
      title: "Title",
      content: "__Content__"
    }
  end
end
