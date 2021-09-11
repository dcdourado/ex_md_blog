import Config

config :auth_blog,
  ecto_repos: [AuthBlog.Repo]

import_config "#{Mix.env()}.exs"
