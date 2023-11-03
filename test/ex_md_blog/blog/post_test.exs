defmodule ExMdBlog.Posts.PostTest do
  use ExMdBlog.RepoCase, async: true

  alias ExMdBlog.Posts.Post
  alias ExMdBlog.Repo

  alias Ecto.Changeset

  describe "changeset/1" do
    test "creates a valid changeset when given params are valid" do
      params = %{
        title: "Title",
        content: "Content"
      }

      assert %Changeset{valid?: true, changes: %{title: _, content: _}} = Post.changeset(params)
    end

    test "validates required field creating an invalid changeset if params are invalid" do
      params = %{}

      assert %Changeset{
               valid?: false,
               errors: [
                 title: {"can't be blank", [validation: :required]},
                 content: {"can't be blank", [validation: :required]}
               ]
             } = Post.changeset(params)
    end

    test "does not cast deleted_at" do
      params = %{
        title: "Title",
        content: "Content",
        deleted_at: NaiveDateTime.utc_now()
      }

      %Changeset{changes: changes} = Post.changeset(params)

      assert changes
             |> Map.keys()
             |> Enum.any?(&(&1 == :deleted_at)) == false
    end
  end

  describe "changeset/2" do
    setup do
      params = %{
        title: "BeforeTitle",
        content: "BeforeContent"
      }

      {:ok, post} =
        params
        |> Post.changeset()
        |> Repo.insert()

      {:ok, post: post}
    end

    test "casts all params", ctx do
      params = %{
        title: "AfterTitle",
        content: "AfterContent",
        deleted_at: NaiveDateTime.utc_now()
      }

      assert %Changeset{
               valid?: true,
               changes: %{title: _, content: _, deleted_at: _}
             } = Post.changeset(ctx.post, params)
    end

    test "validates if post is already deleted", ctx do
      post = %{ctx.post | deleted_at: NaiveDateTime.utc_now()}

      assert %Changeset{valid?: false, errors: [deleted_at: {"can't update a deleted post", []}]} =
               Post.changeset(post, %{title: "BeforeTitle"})
    end

    test "validates title length", ctx do
      assert %Changeset{
               valid?: false,
               errors: [
                 title:
                   {"should be at most %{count} character(s)",
                    [count: 120, validation: :length, kind: :max, type: :string]}
               ]
             } = Post.changeset(ctx.post, %{title: gen_string(121)})
    end
  end

  defp gen_string(length) do
    Enum.reduce(1..length, "", fn _i, acc -> " " <> acc end)
  end
end
