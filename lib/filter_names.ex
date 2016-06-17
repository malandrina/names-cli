defmodule FilterNames do
  def run(options) do
    all_names
    |> FilterBySex.exclude_female_names(options[:male_only])
    |> FilterBySex.exclude_male_names(options[:female_only])
    |> FilterByPrefix.run(options[:begins_with])
    |> FilterByContains.run(options[:does_not_contain])
    |> Enum.map(&Name.name/1)
  end

  defp all_names do
    filepath = Application.get_env(:names_cli, :data_path)
    {:ok, contents } = File.read(filepath)
    [_header | rows ] = String.split(contents, "\n")
    rows
  end
end
