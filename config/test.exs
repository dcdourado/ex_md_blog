import Config

config :auth_blog, AuthBlog.Repo,
  database: "auth_blog_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
