defmodule Name do
  def where(options) do
    options[:begins_with]
    |> beginning_with
  end

  defp beginning_with(begins_with) do
    begins_with
    |> filtered_by_begins_with
    |> extract_names
  end

  defp filtered_by_begins_with(begins_with) do
    Enum.filter_map(
      grouped_by_begins_with(begins_with),
      fn(names_by_letter) -> begins_with?(begins_with, names_by_letter) end,
      fn(filtered_names) -> elem(filtered_names, 1) end
    )
  end

  defp grouped_by_begins_with(_begins_with) do
    Enum.group_by(all_names, &String.first/1)
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

  defp begins_with?(_letters, {nil, [""]}) do
    false
  end

  defp begins_with?(letters, names_by_letter) do
    letter = elem(names_by_letter, 0)
    Enum.member?(letters, letter)
  end

  defp names(item) do
    Enum.map(item, fn(foo) -> name(foo) end)
  end

  defp name(item) do
    [_letter, name, _tail] = String.split item, ",", parts: 3
    name
  end
end
