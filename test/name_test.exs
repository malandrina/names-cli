defmodule NameTest do
  use ExUnit.Case, async: true
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
end
