defmodule AuthBlog.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: AuthBlog.Repo

  alias AuthBlog.Blog.Post

  def post_factory do
    %Post{
      title: "Title",
      description: "Description",
      content: "__Content__"
    }
  end
end
