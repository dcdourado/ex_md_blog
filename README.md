[![Actions Status](https://github.com/dcdourado/ex_md_blog/workflows/Elixir%20CI/badge.svg)](https://github.com/dcdourado/ex_md_blog/actions/workflows/elixir-ci.yml)

# ExMdBlog

https://dcdourado.me/

The blog goal is to learn, write and practice about software engineering principles.
I want to write more stuff and maybe this is going to be an incentive to do it more.


## Setup

Configure the `GOOGLE_APPLICATION_CREDENTIALS_JSON` environment variable to authorize Google Drive posts.

```shell
asdf install

mix deps.get
mix deps.compile
mix compile

# run
iex -S mix
```

Blog can be accessed locally at http://localhost:8080/

## Deploy

```shell
flyctl deploy
```
