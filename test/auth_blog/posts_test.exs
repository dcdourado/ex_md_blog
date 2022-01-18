defmodule AuthBlog.PostsTest do
  use AuthBlog.RepoCase, async: true

  import AuthBlog.Factory

  alias AuthBlog.Posts
  alias AuthBlog.Posts.Post

  alias Ecto.Changeset
  alias Ecto.UUID

  describe "fetch/1" do
    test "fetches a post when given params are related to only one result" do
      post = insert(:post)

      assert {:ok, ^post} = Posts.fetch(id: post.id)
    end

    test "returns an error when no record was found" do
      assert {:error, :not_found} == Posts.fetch(id: UUID.generate())
    end

    test "returns an error when more than one result is found" do
      insert_list(2, :post, title: "common title")

      assert {:error, :too_many_results} == Posts.fetch(title: "common title")
    end
  end

  describe "list/1" do
    test "lists all posts" do
      insert_list(5, :post)

      assert {:ok, [_post1, _post2, _post3, _post4, _post5]} = Posts.list()
    end
  end

  describe "insert/1" do
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
              }} = Posts.insert(params)
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
              }} = Posts.insert(%{})
    end
  end

  describe "update/2" do
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
              }} = Posts.update(post, params)
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
              }} = Posts.update(post, params)
    end
  end

  describe "delete/2" do
    test "deletes a post when called" do
      %{deleted_at: nil} = post = insert(:post)

      assert :ok == Posts.delete(post)

      assert {:ok, %Post{deleted_at: %NaiveDateTime{}}} = Posts.fetch(id: post.id)
    end
  end

  describe "to_html/1" do
    test "returns a valid html when post is correctly filled" do
      post = insert(:post, content: "Simple content")

      assert """
             <h1>#{post.title}</h1>
             <h2>#{post.description}</h2>
             <p>#{post.content}</p>
             """
             |> String.replace("\n", "") == Posts.to_html(post)
    end
  end
end
