defmodule ExMdBlog.PostsTest do
  use ExUnit.Case, async: true

  import ExMdBlog.Factory

  alias ExMdBlog.Posts
  alias ExMdBlog.Posts.Post

  @existing_post_id "dependency-inversion-on-elixir-using-ports-and-adapters-design-pattern"

  describe "list/0" do
    test "returns a list of posts" do
      assert [%Post{} | _] = Posts.list()
    end
  end

  describe "to_html/1" do
    test "returns a valid html when post is correctly filled" do
      post = %{title: title, content: content} = post_factory()
      content = String.replace(content, "__", "")

      assert """
             <section>
             <h1>#{title}</h1>
             <p><strong>#{content}</strong></p>
             </section>
             """
             |> String.replace("\n", "") == Posts.to_html(post)
    end
  end
end
