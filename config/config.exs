import Config

config :auth_blog, AuthBlog.Repo,
  database: "auth_blog_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :auth_blog,
  ecto_repos: [AuthBlog.Repo]
