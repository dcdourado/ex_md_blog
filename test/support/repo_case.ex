defmodule AuthBlog.RepoCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  alias Ecto.Adapters.SQL.Sandbox

  using do
    quote do
      alias AuthBlog.Repo

      import AuthBlog.RepoCase
    end
  end

  setup tags do
    :ok = Sandbox.checkout(AuthBlog.Repo)

    unless tags[:async] do
      Sandbox.mode(AuthBlog.Repo, {:shared, self()})
    end

    :ok
  end
end
