defmodule AuthBlog.RepoCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  using do
    quote do
      alias AuthBlog.Repo

      import AuthBlog.RepoCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(AuthBlog.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(AuthBlog.Repo, {:shared, self()})
    end

    :ok
  end
end
