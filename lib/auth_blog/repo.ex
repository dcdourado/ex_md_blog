defmodule AuthBlog.Repo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :auth_blog,
    adapter: Ecto.Adapters.Postgres
end
