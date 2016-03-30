defmodule RandomSelectionTest do
  use ExUnit.Case
  doctest TeamBuilder
  alias TeamBuilder.RandomSelection

  test "any 4 elements selected from collection" do
    team_count = 4
    members = ["name1", "name2", "name3", "name4", "name5"]
    assert contains_all?(members, RandomSelection.take_random(members, team_count))
  end

  def contains_all?(members, selection) do
    Enum.all?(selection, fn(s) -> Enum.member?(members, s) end)
  end
end
