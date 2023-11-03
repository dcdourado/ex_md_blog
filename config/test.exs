import Config

config :ex_md_blog, ExMdBlog.Repo,
  database: "ex_md_blog_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
