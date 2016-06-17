defmodule FilterBySex do
  def exclude_female_names(names, nil), do: names
  def exclude_female_names(names, true) do
    Enum.filter_map(
      grouped_by_sex(names),
      &male?/1,
      fn(filtered_names) -> elem(filtered_names, 1) end
    )
    |> List.flatten
  end

  def exclude_male_names(names, nil), do: names
  def exclude_male_names(names, true) do
    Enum.filter_map(
      grouped_by_sex(names),
      &female?/1,
      fn(filtered_names) -> elem(filtered_names, 1) end
    )
    |> List.flatten
  end

  defp grouped_by_sex(names) do
    Enum.group_by(names, &Name.sex/1)
  end

  defp female?(names_by_sex) do
    sex = elem(names_by_sex, 0)
    sex == Name.female_sex || sex == Name.both_sexes
  end

  defp male?(names_by_sex) do
    sex = elem(names_by_sex, 0)
    sex == Name.male_sex || sex == Name.both_sexes
  end
end
