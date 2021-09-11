defmodule AuthBlog.BlogTest do
  use AuthBlog.RepoCase, async: true

  import AuthBlog.Factory

  alias AuthBlog.Blog
  alias AuthBlog.Blog.Post

  alias Ecto.Changeset
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

  describe "insert_post/1" do
    test "inserts a post when params are valid" do
      params = %{
        title: "My testing post",
        description: "It's not very informative",
        content: "I told you so."
      }

      assert {:ok,
              %Post{
                title: "My testing post",
                description: "It's not very informative",
                content: "I told you so."
              }} = Blog.insert_post(params)
    end

    test "returns an error when params are invalid" do
      assert {:error,
              %Changeset{
                valid?: false,
                errors: [
                  title: {"can't be blank", [validation: :required]},
                  description: {"can't be blank", [validation: :required]},
                  content: {"can't be blank", [validation: :required]}
                ]
              }} = Blog.insert_post(%{})
    end
  end

  describe "update_post/2" do
    test "updates post when params are valid" do
      post = insert(:post)

      params = %{
        title: "My updated testing post",
        description: "It's not very informative too",
        content: "shh.",
        deleted_at: NaiveDateTime.utc_now()
      }

      assert {:ok,
              %Post{
                title: "My updated testing post",
                description: "It's not very informative too",
                content: "shh.",
                deleted_at: %NaiveDateTime{}
              }} = Blog.update_post(post, params)
    end

    test "returns an error when params are invalid" do
      post = insert(:post)

      params = %{
        title: %{invalid: :parameter},
        description: %{invalid: :parameter},
        content: %{invalid: :parameter},
        deleted_at: %{invalid: :parameter}
      }

      assert {:error,
              %Changeset{
                valid?: false,
                errors: [
                  title: {"is invalid", [type: :string, validation: :cast]},
                  description: {"is invalid", [type: :string, validation: :cast]},
                  content: {"is invalid", [type: :string, validation: :cast]},
                  deleted_at: {"is invalid", [type: :naive_datetime, validation: :cast]}
                ]
              }} = Blog.update_post(post, params)
    end
  end

  describe "delete_post/2" do
    test "deletes a post when called" do
      %{deleted_at: nil} = post = insert(:post)

      assert :ok == Blog.delete_post(post)

      assert {:ok, %Post{deleted_at: %NaiveDateTime{}}} = Blog.fetch_post(id: post.id)
    end
  end
end
