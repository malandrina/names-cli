defmodule NamesCli.Mixfile do
  use Mix.Project

  def project do
    [app: :names_cli,
     version: "0.0.1",
     elixir: "~> 1.2",
     escript: [main_module: NamesCli],
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    Envy.auto_load
    [applications: [:logger]]
  end

  defp deps do
    [{:envy, "~> 0.0.2"}]
  end
end
