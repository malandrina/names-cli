defmodule Name do
  def where(options) do
    all_names
    |> female(options[:female])
    |> male(options[:male])
    |> beginning_with(options[:begins_with])
    |> does_not_contain(options[:does_not_contain])
    |> extract_names
  end

  defp female(collection, nil) do
    collection
  end

  defp female(collection, true) do
    Enum.filter_map(
      grouped_by_sex(collection),
      &female?/1,
      fn(filtered_names) -> elem(filtered_names, 1) end
    )
    |> List.flatten
  end

  defp male(collection, nil) do
    collection
  end

  defp male(collection, true) do
    Enum.filter_map(
      grouped_by_sex(collection),
      &male?/1,
      fn(filtered_names) -> elem(filtered_names, 1) end
    )
    |> List.flatten
  end

  defp grouped_by_sex(collection) do
    Enum.group_by(collection, fn(row) -> sex(String.split(row, ",")) end)
  end

  defp female?(names_by_sex) do
    sex = elem(names_by_sex, 0)
    sex == "female" || sex == "both"
  end

  defp male?(names_by_sex) do
    sex = elem(names_by_sex, 0)
    sex == "male" || sex == "both"
  end

  defp sex([""]) do
    nil
  end

  defp sex(row) do
    male = Enum.at(row, 2)
    female = Enum.at(row, 3)

    cond do
      male == "Yes" && female == "Yes" ->
        "both"
      male == "Yes" ->
        "male"
      female == "Yes" ->
        "female"
    end
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

  defp filtered_by_excluded(excluded, collection) do
    Enum.filter_map(
      collection,
      fn(row) -> does_not_contain?(excluded, name(row)) end,
      fn(filtered_name) -> filtered_name end
    )
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

  defp name("") do
    ""
  end

  defp name(item) do
    [_letter, name, _tail] = String.split item, ",", parts: 3
    name
  end
end
