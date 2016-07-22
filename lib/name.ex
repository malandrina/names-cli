defmodule Name do
  def both_sexes, do: "both"
  def female_sex, do: "female"
  def male_sex, do: "male"

  def does_not_contain?(row, excluded) do
    !String.contains?(
      downcased_name(row),
      Enum.map(excluded, &String.downcase/1)
    )
  end

  def prefix(row, begin, prefix_length) do
    name(row)
    |> String.slice(begin, prefix_length)
  end

  def suffix(row, suffix_length) do
    name(row)
    |> String.slice(-suffix_length, suffix_length)
  end

  def sex(""), do: nil
  def sex(row) do
    split_row = String.split(row, ",")
    male = Enum.at(split_row, 2)
    female = Enum.at(split_row, 3)
    sex(male, female)
  end

  def name(""), do: ""
  def name(row) do
    [_letter, name, _tail] = String.split row, ",", parts: 3
    name
  end

  def name_and_meanings(""), do: ""
  def name_and_meanings(row) do
    [_letter, name, _, _, _, meanings, _tail] = String.split row, ",", parts: 7
    "#{name} - #{meanings}"
  end

  defp sex("Yes", "Yes"), do: both_sexes
  defp sex(_, "Yes"), do: female_sex
  defp sex("Yes", _), do: male_sex
  defp sex(_, _), do: both_sexes

  defp downcased_name(row) do
    String.downcase(name(row))
  end
end
