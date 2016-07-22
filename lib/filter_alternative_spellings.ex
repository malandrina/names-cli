defmodule FilterAlternativeSpellings do
  def run(names) do
    Enum.reject(names, fn(row) -> Name.is_alternative_spelling?(row) end)
  end
end
