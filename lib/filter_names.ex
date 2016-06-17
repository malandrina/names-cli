defmodule FilterNames do
  def run(options) do
    all_names
    |> FilterBySex.exclude_female_names(options[:male_only])
    |> FilterBySex.exclude_male_names(options[:female_only])
    |> beginning_with(options[:begins_with])
    |> does_not_contain(options[:does_not_contain])
    |> extract_names
  end

  defp beginning_with(collection, prefixes) do
    prefixes
    |> filtered_by_prefix(collection)
  end

  defp does_not_contain(collection, nil) do
    collection
  end

  defp does_not_contain(collection, excluded) do
    excluded
    |> filtered_by_excluded(collection)
  end

  defp filtered_by_prefix(nil, collection) do
    collection
  end

  defp filtered_by_prefix(prefixes, collection) do
    longest_prefix_length = Enum.map(prefixes, &String.length/1) |> Enum.max
    Enum.filter_map(
      grouped_by_prefix(collection, longest_prefix_length),
      fn(names_by_letter) -> starts_with?(prefixes, names_by_letter) end,
      fn(filtered_names) -> elem(filtered_names, 1) end
    )
    |> List.flatten
  end

  defp filtered_by_excluded(excluded, collection) do
    Enum.filter_map(
      collection,
      fn(row) -> does_not_contain?(excluded, name(row)) end,
      fn(filtered_name) -> filtered_name end
    )
  end

  defp grouped_by_prefix(collection, prefix_length) do
    Enum.group_by(collection, fn(row) -> String.slice(name(row), 0, prefix_length) end)
  end

  defp does_not_contain?(excluded, name) do
    downcased_name = String.downcase(name)
    name_contains_excludes = String.contains?(downcased_name, Enum.map(excluded, &String.downcase/1))

    cond do
      name_contains_excludes == false ->
        true
      name_contains_excludes == true ->
        false
    end
  end

  defp extract_names(collection) do
    Enum.map(collection, &name/1)
  end

  defp all_names do
    filepath = Application.get_env(:names_cli, :data_path)
    {:ok, contents } = File.read(filepath)
    [_header | rows ] = String.split(contents, "\n")
    rows
  end

  defp starts_with?(_letters, {nil, [""]}) do
    false
  end

  defp starts_with?(prefixes, names_by_letter) do
    elem(names_by_letter, 0)
    |> String.downcase
    |> String.starts_with?(Enum.map(prefixes, &String.downcase/1))
  end

  defp name("") do
    ""
  end

  defp name(item) do
    [_letter, name, _tail] = String.split item, ",", parts: 3
    name
  end
end
