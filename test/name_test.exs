defmodule NameTest do
  use ExUnit.Case, async: true

  test "returns names beginning with given letters" do
    options = %{begins_with: ["S","V"]}
    expected_names = ["Sita","Shiva","Saraswati","Vishnu"]

    names = Name.where(options)

    assert names == expected_names
  end
end
