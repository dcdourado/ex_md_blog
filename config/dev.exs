import Config

config :auth_blog, AuthBlog.Repo,
  database: "auth_blog_dev",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"
