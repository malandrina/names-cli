defmodule FilterBySuffix do
  def run(names, nil), do: names
  def run(names, does_not_end_with) do
    longest_suffix_length = Enum.map(does_not_end_with, &String.length/1) |> Enum.max
    Enum.filter_map(
      grouped_by_suffix(names, longest_suffix_length),
      fn(names_by_letter) -> !ends_with?(does_not_end_with, names_by_letter) end,
      fn(filtered_names) -> elem(filtered_names, 1) end
    )
    |> List.flatten
  end

  defp grouped_by_suffix(names, suffix_length) do
    Enum.group_by(names, fn(row) -> Name.suffix(row, suffix_length) end)
  end

  defp ends_with?(_letters, {nil, [""]}) do
    false
  end

  defp ends_with?(suffixes, names_by_letter) do
    elem(names_by_letter, 0)
    |> String.downcase
    |> String.ends_with?(Enum.map(suffixes, &String.downcase/1))
  end
end
