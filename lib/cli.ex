defmodule Cli do
  def run(argv) do
    argv
    |> parse_args
    |> transform_options
    |> find_names
  end

  defp parse_args(argv) do
    {parsed_switches, _remaining_args, _invalid_options} = OptionParser.parse(
      argv,
      strict: [
        begins_with: :string,
        male: :boolean,
        female: :boolean,
        does_not_contain: :string,
      ],
    )
    parsed_switches
  end

  defp transform_options([]) do
    []
  end

  defp transform_options(options) do
    %{
      begins_with: split_on_commas(options[:begins_with]),
      does_not_contain: split_on_commas(options[:does_not_contain]),
      female: options[:female],
      male: options[:male],
    }
  end

  defp find_names([]) do
    IO.puts "No arguments given"
  end

  defp find_names(options) do
    names = Name.where(options)
    IO.puts(Enum.join(names, "\n"))
  end

  defp split_on_commas(nil) do
    nil
  end

  defp split_on_commas(string) do
    String.split(string, ",")
  end
end
