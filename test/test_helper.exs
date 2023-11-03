Ecto.Adapters.SQL.Sandbox.mode(ExMdBlog.Repo, :manual)
Logger.configure(level: :info)
{:ok, _} = Application.ensure_all_started(:ex_machina)
ExUnit.start()
