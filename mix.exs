defmodule ExMdBlog.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_md_blog,
      version: "1.0.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),
      aliases: aliases(),
      preferred_cli_env: cli_env()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :eex],
      mod: {ExMdBlog.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Webserver
      {:cowboy, "~> 2.10.0"},

      # JSON parsing
      {:jason, "~> 1.4.1"},

      # Code style
      {:credo, "~> 1.7.1", only: [:dev, :test], runtime: false},

      # Observing
      {:telemetry, "~> 1.2.1"}
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
    []
  end
end
