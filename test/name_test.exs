defmodule NameTest do
  use ExUnit.Case, async: true

  test "returns female and unisex names when 'female' option is present" do
    options = %{female: true}
    expected_names = ["Shiva", "Rama", "Indra", "Sita", "Saraswati", "Parvati"]

    names = Name.where(options)

    assert names == expected_names
  end

  test "returns male and unisex names when 'male' option is present" do
    options = %{male: true}
    expected_names = ["Shiva", "Rama", "Indra", "Vishnu", "Lakshman"]

    names = Name.where(options)

    assert names == expected_names
  end

  test "returns names beginning with given uppercase letters" do
    options = %{begins_with: ["Sh","V"]}
    expected_names = ["Shiva","Vishnu"]

    names = Name.where(options)

    assert names == expected_names
  end

  test "returns names beginning with given lowercase letters" do
    options = %{begins_with: ["sh","v"]}
    expected_names = ["Shiva","Vishnu"]

    names = Name.where(options)

    assert names == expected_names
  end

  test "filters by sex and prefix" do
    options = %{female: true, begins_with: ["l"]}
    expected_names = []

    names = Name.where(options)

    assert names == expected_names
  end
end
