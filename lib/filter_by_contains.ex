defmodule FilterByContains do
  def run(names, nil), do: names
  def run(names, excludes) do
    Enum.filter_map(
      names,
      fn(row) -> Name.does_not_contain?(row, excludes) end,
      fn(filtered_name) -> filtered_name end
    )
  end
end
