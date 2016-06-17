defmodule FilterBySex do
  def exclude_female_names(names, nil) do names end
  def exclude_female_names(names, true) do
    Enum.filter_map(
      grouped_by_sex(names),
      &male?/1,
      fn(filtered_names) -> elem(filtered_names, 1) end
    )
    |> List.flatten
  end

  def exclude_male_names(names, nil) do names end
  def exclude_male_names(names, true) do
    Enum.filter_map(
      grouped_by_sex(names),
      &female?/1,
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
      male != "Yes" && female != "Yes" ->
        "both"
      male == "Yes" ->
        "male"
      female == "Yes" ->
        "female"
    end
  end
end
