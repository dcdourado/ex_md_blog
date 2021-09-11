defmodule AuthBlog.Repo do
  use Ecto.Repo,
    otp_app: :auth_blog,
    adapter: Ecto.Adapters.Postgres
end
