defmodule Name do
  def where(options) do
    options[:begins_with]
    |> beginning_with
  end

  defp beginning_with(prefixes) do
    prefixes
    |> filtered_by_prefix
    |> extract_names
  end

  defp filtered_by_prefix(prefixes) do
    longest_prefix_length = Enum.map(prefixes, &String.length/1) |> Enum.max
    Enum.filter_map(
      grouped_by_prefix(longest_prefix_length),
      fn(names_by_letter) -> starts_with?(prefixes, names_by_letter) end,
      fn(filtered_names) -> elem(filtered_names, 1) end
    )
  end

  defp grouped_by_prefix(prefix_length) do
    Enum.group_by(all_names, fn(row) -> String.slice(name(row), 0, prefix_length) end)
  end

  defp extract_names(collection) do
    Enum.flat_map(collection, fn(item) -> names(item) end)
  end

  defp all_names do
    filepath = Application.get_env(:name_finder, :path_to_names)
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

  defp names(items) do
    Enum.map(items, fn(item) -> name(item) end)
  end

  defp name("") do
    ""
  end

  defp name(item) do
    [_letter, name, _tail] = String.split item, ",", parts: 3
    name
  end
end
