defmodule FilterNamesTest do
  use ExUnit.Case, async: true

  test "excludes names containing undesired substrings" do
    options = %{does_not_contain: ["ndr"]}
    expected_names = [
      "Lakshman",
      "Parvati",
      "Rama",
      "Saraswati",
      "Shiva",
      "Sita",
      "Vishnu",
      "",
    ]

    names = FilterNames.run(options)

    assert names == expected_names
  end

  test "returns female and unisex names when 'female' option is present" do
    options = %{female: true}
    expected_names = ["Shiva", "Rama", "Indra", "Sita", "Saraswati", "Parvati"]

    names = FilterNames.run(options)

    assert names == expected_names
  end

  test "returns male and unisex names when 'male' option is present" do
    options = %{male: true}
    expected_names = ["Shiva", "Rama", "Indra", "Vishnu", "Lakshman"]

    names = FilterNames.run(options)

    assert names == expected_names
  end

  test "returns names beginning with given uppercase letters" do
    options = %{begins_with: ["Sh","V"]}
    expected_names = ["Shiva","Vishnu"]

    names = FilterNames.run(options)

    assert names == expected_names
  end

  test "returns names beginning with given lowercase letters" do
    options = %{begins_with: ["sh","v"]}
    expected_names = ["Shiva","Vishnu"]

    names = FilterNames.run(options)

    assert names == expected_names
  end

  test "filters by sex, prefix, and undesired substrings" do
    options = %{male: true, begins_with: ["i"], does_not_contain: ["ndr"]}
    expected_names = []

    names = FilterNames.run(options)

    assert names == expected_names
  end
end
