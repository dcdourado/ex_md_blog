defmodule ExMdBlog.RepoCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  alias Ecto.Adapters.SQL.Sandbox

  using do
    quote do
      alias ExMdBlog.Repo

      import ExMdBlog.RepoCase
    end
  end

  setup tags do
    :ok = Sandbox.checkout(ExMdBlog.Repo)

    unless tags[:async] do
      Sandbox.mode(ExMdBlog.Repo, {:shared, self()})
    end

    :ok
  end
end
