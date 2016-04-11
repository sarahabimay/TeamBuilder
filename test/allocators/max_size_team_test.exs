defmodule Allocators.MaxSizeTeamTest do
  use ExUnit.Case
  alias TeamBuilder.Allocators.MaxSizeTeam

  setup do
    {:ok, seed_state: :rand.export_seed_s(:rand.seed(:exsplus)) }
  end

  test "assign members to a max member sized team", context do
    max_size = 4
    members = TestHelper.generate_members(4)
    [a1, a2, a3, a4] = Enum.take_random(members, max_size)
    expected_teams = [
      %{ :member => a1, :team => 1 },
      %{ :member => a2, :team => 1 },
      %{ :member => a3, :team => 1 },
      %{ :member => a4, :team => 1 }
    ]
    {teams, _ } = MaxSizeTeam.assign_teams(members, max_size, context[:seed_state])
    assert teams == expected_teams
  end

  test "max member size is one", context do
    max_size = 1
    members = TestHelper.generate_members(2)
    [a1] = Enum.take_random(members, max_size)
    [a2] = TestHelper.remaining_members([a1], members)
    expected_teams = [
      %{ :member => a1, :team => 2 },
      %{ :member => a2, :team => 1 },
    ]
    {teams, _ } = MaxSizeTeam.assign_teams(members, max_size, context[:seed_state])
    assert teams == expected_teams
  end

  test "members are a factor of the max number of members", context do
    max_size = 4
    members = TestHelper.generate_members(8)
    {teams, _ } = MaxSizeTeam.assign_teams(members, max_size, context[:seed_state])
    members_in_team1 = count_members(teams, 1)
    members_in_team2 = count_members(teams, 2)
    assert [members_in_team1, members_in_team2] == [4, 4]
  end

  test "assign uneven number of members to teams", context do
    max_size = 4
    members = TestHelper.generate_members(5)
    {teams, _ } = MaxSizeTeam.assign_teams(members, max_size, context[:seed_state])
    members_in_team1 = count_members(teams, 1)
    members_in_team2 = count_members(teams, 2)
    assert [members_in_team1, members_in_team2] == [3, 2]
  end

  def count_members(teams, team_number) do
    Enum.count(Enum.filter(teams, fn(team) -> team[:team] == team_number end))
  end
end
