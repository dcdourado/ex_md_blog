defmodule ExMdBlog.PostsTest do
  use ExUnit.Case, async: true

  import ExMdBlog.Factory

  alias ExMdBlog.Posts
  alias ExMdBlog.Posts.Post

  @existing_post_id "dependency-inversion-on-elixir-using-ports-and-adapters-design-pattern"

  describe "fetch/1" do
    test "fetches a post when given params are related to only one result" do
      assert {:ok, %Post{id: @existing_post_id}} = Posts.fetch(@existing_post_id)
    end

    test "returns an error when no record was found" do
      assert {:error, :not_found} == Posts.fetch("not-existing-id")
    end
  end

  describe "list/0" do
    test "returns a list of posts" do
      assert [%Post{id: @existing_post_id} | _] = Posts.list()
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
