defmodule AuthBlog.MixProject do
  use Mix.Project

  def project do
    [
      app: :auth_blog,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      {:cowboy, "~> 2.9.0"},
      {:jason, "~> 1.2.2"},
      {:credo, "~> 1.5.6", only: [:dev, :test], runtime: false}
    ]
  end
end
