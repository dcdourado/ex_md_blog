defmodule AuthBlog.BlogTest do
  use AuthBlog.RepoCase

  import AuthBlog.Factory

  alias AuthBlog.Blog

  alias Ecto.UUID

  describe "fetch_post/1" do
    test "fetches a post when given params are related to only one result" do
      post = insert(:post)

      assert {:ok, ^post} = Blog.fetch_post(id: post.id)
    end

    test "returns an error when no record was found" do
      assert {:error, :not_found} == Blog.fetch_post(id: UUID.generate())
    end

    test "returns an error when more than one result is found" do
      insert_list(2, :post, title: "common title")

      assert {:error, :too_many_results} == Blog.fetch_post(title: "common title")
    end
  end

  describe "list_post/1" do
    test "lists all posts" do
      insert_list(5, :post)

      assert {:ok, [_post1, _post2, _post3, _post4, _post5]} = Blog.list_post()
    end
  end

  # describe "insert_post/1" do

  # end

  # describe "update_post/2" do

  # end

  # describe "delete_post/2" do

  # end
end
