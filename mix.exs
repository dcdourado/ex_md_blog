defmodule AuthBlog.MixProject do
  use Mix.Project

  def project do
    [
      app: :auth_blog,
      version: "0.3.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),
      aliases: aliases(),
      preferred_cli_env: cli_env()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {AuthBlog.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Webserver
      {:cowboy, "~> 2.9.0"},

      # JSON parsing
      {:jason, "~> 1.2.2"},

      # Code style
      {:credo, "~> 1.5.6", only: [:dev, :test], runtime: false},

      # Database
      {:ecto_sql, "~> 3.7.0"},
      {:postgrex, "~> 0.15.10"},

      # Testing
      {:ex_machina, "~> 2.7.0", only: :test}
    ]
  end

  defp elixirc_paths(:test) do
    ["lib", "test/support"]
  end

  defp elixirc_paths(_) do
    ["lib"]
  end

  defp cli_env do
    [
      "test.setup": :test,
      "test.reset": :test
    ]
  end

  defp aliases do
    [
      setup: ["ecto.create", "ecto.migrate"],
      reset: ["ecto.drop", "setup"],
      "test.setup": ["ecto.create", "ecto.migrate"],
      "test.reset": ["ecto.drop", "test.setup"]
    ]
  end
end
