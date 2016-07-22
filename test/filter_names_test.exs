defmodule FilterNamesTest do
  use ExUnit.Case, async: true

  test "excludes alternative spellings" do
    names = FilterNames.run(%{})

    refute Enum.member?(names, "Vishnoo - Protector of the worlds.")
  end

  test "excludes names with undesired endings" do
    options = %{does_not_end_with: ["ndra", "ati"]}

    names = FilterNames.run(options)

    refute Enum.member?(names, "Parvati - Daughter of the mountain.")
    refute Enum.member?(names, "Saraswati - Wisdom")
    refute Enum.member?(names, "Indra - Supreme god.")
  end

  test "excludes names containing undesired substrings" do
    options = %{does_not_contain: ["ndr"]}

    names = FilterNames.run(options)

    refute Enum.member?(names, "Indra - Supreme god.")
  end

  test "returns female and unisex names when 'female_only' option is present" do
    options = %{female_only: true}
    expected_names = [
      "Indra - Supreme god.",
      "Parvati - Daughter of the mountain.",
      "Rama - Follower of the Father",
      "Saraswati - Wisdom",
      "Shiva - God of the moon.",
      "Sita - Goddess of the land.",
    ]

    names = FilterNames.run(options)

    assert names == expected_names
  end

  test "returns male and unisex names when 'male_only' option is present" do
    options = %{male_only: true}
    expected_names = [
      "Indra - Supreme god.",
      "Lakshman - Prosperous",
      "Rama - Follower of the Father",
      "Shiva - God of the moon.",
      "Vishnu - Protector of the worlds.",
    ]

    names = FilterNames.run(options)

    assert names == expected_names
  end

  test "returns names beginning with given uppercase letters" do
    options = %{begins_with: ["Sh","V"]}
    expected_names = [
      "Shiva - God of the moon.",
      "Vishnu - Protector of the worlds.",
    ]

    names = FilterNames.run(options)

    assert names == expected_names
  end

  test "returns names beginning with given lowercase letters" do
    options = %{begins_with: ["sh","v"]}
    expected_names = [
      "Shiva - God of the moon.",
      "Vishnu - Protector of the worlds.",
    ]

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
    expected_names = ["Shiva - God of the moon.", "Sita - Goddess of the land."]

    names = FilterNames.run(options)

    assert names == expected_names
  end
end
