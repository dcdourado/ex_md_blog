import Config

config :ex_md_blog,
  ecto_repos: [ExMdBlog.Repo]

import_config "#{Mix.env()}.exs"
