defmodule FilterNamesTest do
  use ExUnit.Case, async: true

  test "excludes names with undesired endings" do
    options = %{does_not_end_with: ["ndra", "ati"]}

    names = FilterNames.run(options)

    refute Enum.member?(names, "Parvati")
    refute Enum.member?(names, "Saraswati")
    refute Enum.member?(names, "Indra")
  end

  test "excludes names containing undesired substrings" do
    options = %{does_not_contain: ["ndr"]}

    names = FilterNames.run(options)

    refute Enum.member?(names, "Indra")
  end

  test "returns female and unisex names when 'female_only' option is present" do
    options = %{female_only: true}
    expected_names = ["Shiva", "Rama", "Indra", "Sita", "Saraswati", "Parvati"]

    names = FilterNames.run(options)

    assert names == expected_names
  end

  test "returns male and unisex names when 'male_only' option is present" do
    options = %{male_only: true}
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

  test "filters by sex, prefix, undesired substrings, and undesired endings" do
    options = %{
      female_only: true,
      begins_with: ["s","p"],
      does_not_contain: ["arv"],
      does_not_end_with: ["ati"],
    }
    expected_names = ["Sita", "Shiva"]

    names = FilterNames.run(options)

    assert names == expected_names
  end
end
