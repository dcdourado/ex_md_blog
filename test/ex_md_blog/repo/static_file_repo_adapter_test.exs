defmodule ExMdBlog.Repo.StaticFileRepoAdapterTest do
  use ExUnit.Case, async: true

  alias ExMdBlog.Posts.Post
  alias ExMdBlog.Repo.StaticFileRepoAdapter

  @existing_post_id "dependency-inversion-on-elixir-using-ports-and-adapters-design-pattern"

  describe "fetch/1" do
    test "returns {:ok, post} when file exists" do
      assert {:ok, %Post{}} = StaticFileRepoAdapter.fetch(@existing_post_id)
    end

    test "returns not found when file doesn't exist" do
      assert {:error, :not_found} = StaticFileRepoAdapter.fetch("not-existing-id")
    end
  end
end
