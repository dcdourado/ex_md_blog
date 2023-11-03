defmodule ExMdBlog.Repo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :ex_md_blog,
    adapter: Ecto.Adapters.Postgres
end
