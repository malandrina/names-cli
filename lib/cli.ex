defmodule Cli do
  def run(argv) do
    argv
    |> parse_args
    |> transform_options
    |> find_names
  end

  def parse_args(argv) do
    {parsed_switches, _remaining_args, _invalid_options} = OptionParser.parse(
      argv,
      strict: [begins_with: :string],
    )
    parsed_switches
  end

  def transform_options([]) do
    []
  end

  def transform_options(options) do
    %{begins_with: String.split(options[:begins_with], ",") }
  end

  def find_names([]) do
    IO.puts "No arguments given"
  end

  def find_names(options) do
    names = Name.where(options)
    IO.puts(names)
  end
end
