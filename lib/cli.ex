defmodule Cli do
  def run(argv) do
    argv
    |> parse_args
    |> transform_options
    |> filter_names
    |> print_names
  end

  defp parse_args(argv) do
    {parsed_switches, _remaining_args, _invalid_options} = OptionParser.parse(
      argv,
      strict: permitted_options,
    )
    parsed_switches
  end

  defp permitted_options do
    [
      begins_with: :string,
      male_only: :boolean,
      female_only: :boolean,
      does_not_contain: :string,
    ]
  end

  defp transform_options([]) do [] end
  defp transform_options(options) do
    %{
      begins_with: split(options[:begins_with], ","),
      does_not_contain: split(options[:does_not_contain], ","),
      female_only: options[:female_only],
      male_only: options[:male_only],
    }
  end

  defp split(nil, _delimiter) do nil end
  defp split(string, delimiter) do
    String.split(string, delimiter)
  end

  defp filter_names([]) do [] end
  defp filter_names(options) do
    FilterNames.run(options)
  end

  defp print_names([]) do
    IO.puts("No names found :(")
  end

  defp print_names(names) do
    Enum.join(names, "\n")
    |> IO.puts
  end
end
