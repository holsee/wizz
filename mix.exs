defmodule Wizz.MixProject do
  use Mix.Project

  def project do
    [
      app: :wizz,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Wizz.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug, "~> 1.5"},
      {:cowboy, "~> 1.1"},
      # Only required for the Client
      {:websockex, "~> 0.4"}
    ]
  end
end
