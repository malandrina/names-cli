defmodule FilterByPrefix do
  def run(names, nil), do: names
  def run(names, prefixes) do
    longest_prefix_length = Enum.map(prefixes, &String.length/1) |> Enum.max
    Enum.filter_map(
      grouped_by_prefix(names, longest_prefix_length),
      fn(names_by_letter) -> starts_with?(prefixes, names_by_letter) end,
      fn(filtered_names) -> elem(filtered_names, 1) end
    )
    |> List.flatten
  end

  defp grouped_by_prefix(collection, prefix_length) do
    Enum.group_by(collection, fn(row) -> Name.prefix(row, 0, prefix_length) end)
  end

  defp starts_with?(_letters, {nil, [""]}) do
    false
  end

  defp starts_with?(prefixes, names_by_letter) do
    elem(names_by_letter, 0)
    |> String.downcase
    |> String.starts_with?(Enum.map(prefixes, &String.downcase/1))
  end
end
