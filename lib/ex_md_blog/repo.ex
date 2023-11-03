defmodule ExMdBlog.Repo do
  @moduledoc false

  @default_adapter ExMdBlog.Repo.StaticFileRepoAdapter

  @callback fetch(id :: binary()) :: {:ok, ExMdBlog.Posts.Post.t()} | {:error, :not_found}

  def fetch(id), do: impl().fetch(id)

  defp impl, do: Application.get_env(:ex_md_blog, __MODULE__, @default_adapter)
end
