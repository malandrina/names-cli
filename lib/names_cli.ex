defmodule NamesCli do
  import Cli, only: [run: 1]

  def main(argv) do
    Cli.run(argv)
  end
end
