defmodule RandomTeamAllocatorTest do
  use ExUnit.Case
  doctest TeamBuilder
  alias TeamBuilder.RandomTeamAllocator

  defmodule FakeRandomSelection do
    def take_random(members, count), do: Enum.take(members, count)
  end

  test "assign 1 member to a team" do
    members = ["Sarah"]
    team_type = %{:team_type => :fixed, :options => 4 }
    expected_result = [ %{ :member => "Sarah", :team => 1 } ]
    assert RandomTeamAllocator.assign_teams(members, team_type, FakeRandomSelection) == expected_result
  end

  test "assign 5 members to 4 teams" do
    members = ["name1", "name2", "name3", "name4", "name5"]
    team_type = %{:team_type => :fixed, :options => 4 }
    expected_result = [
      %{ :member => "name1", :team => 1 },
      %{ :member => "name2", :team => 2 },
      %{ :member => "name3", :team => 3 },
      %{ :member => "name4", :team => 4 },
      %{ :member => "name5", :team => 1 }
    ]
    assert RandomTeamAllocator.assign_teams(members, team_type, FakeRandomSelection) == expected_result
  end
end
