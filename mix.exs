defmodule GeoTasks.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      start_permanent: Mix.env() == :prod,
      dialyzer: [plt_add_deps: :transitive, ignore_warnings: "dialyzer.ignore-warnings", plt_add_apps: [:mix]],
      deps: deps()] ++ coveralls_config()
  end

  defp coveralls_config do
    [
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test]
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [
      {:credo, ">= 0.0.0", only: [:dev, :test]},
      {:dialyxir, ">= 0.0.0", only: [:dev, :test], runtime: false},
      {:excoveralls, ">= 0.0.0", only: [:test]}
    ]
  end
end
