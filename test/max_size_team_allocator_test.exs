defmodule MaxSizeTeamAllocatorTest do
  use ExUnit.Case
  doctest TeamBuilder
  alias TeamBuilder.MaxSizeTeamAllocator

  test "max_size_team:4 assign 4 members to one team" do
    members = ["name1", "name2", "name3", "name4"]
    max_size = 4
    seed_state = :rand.export_seed_s(:rand.seed(:exsplus))
    [a1, a2, a3, a4] = Enum.take_random(members, max_size)
    expected_teams = [
      %{ :member => a1, :team => 1 },
      %{ :member => a2, :team => 1 },
      %{ :member => a3, :team => 1 },
      %{ :member => a4, :team => 1 }
    ]
    {teams, _ } = MaxSizeTeamAllocator.assign_teams(members, max_size, seed_state)
    assert teams == expected_teams
  end

  test "max_size_team:4 - members are a factor of the max_size" do
    members = TestHelper.generate_members(8)
    max_size = 4
    expected_number_in_team1 = 4
    expected_number_in_team2 = 4
    seed_state = :rand.export_seed_s(:rand.seed(:exsplus))
    {teams, _ } = MaxSizeTeamAllocator.assign_teams(members, max_size, seed_state)
    members_in_team1 = Enum.count(Enum.filter(teams, fn(team) -> team[:team] == 1 end))
    members_in_team2 = Enum.count(Enum.filter(teams, fn(team) -> team[:team] == 2 end))
    assert [members_in_team1, members_in_team2] == [expected_number_in_team1, expected_number_in_team2]
  end

  test "max_size_team:4 - assign uneven number of members to teams" do
    members = TestHelper.generate_members(5)
    max_size = 4
    expected_number_in_team1 = 2
    expected_number_in_team2 = 3
    seed_state = :rand.export_seed_s(:rand.seed(:exsplus))
    {teams, _ } = MaxSizeTeamAllocator.assign_teams(members, max_size, seed_state)
    members_in_team1 = Enum.count(Enum.filter(teams, fn(team) -> team[:team] == 1 end))
    members_in_team2 = Enum.count(Enum.filter(teams, fn(team) -> team[:team] == 2 end))
    assert [members_in_team1, members_in_team2] == [expected_number_in_team1, expected_number_in_team2]
  end
end
