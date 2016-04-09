defmodule Allocators.FixedTeamTest do
  use ExUnit.Case
  alias TeamBuilder.Allocators.FixedTeam

  test "assign members to a fixed number of teams" do
    team_count = 4
    members = TestHelper.generate_members(team_count)
    seed_state = :rand.export_seed_s(:rand.seed(:exsplus))
    [a1, a2, a3, a4] = Enum.take_random(members, team_count)
    expected_teams = [
      %{ :member => a1, :team => 1 },
      %{ :member => a2, :team => 2 },
      %{ :member => a3, :team => 3 },
      %{ :member => a4, :team => 4 }
    ]
    {teams, _ } = FixedTeam.assign_teams(members, team_count, seed_state)
    assert teams == expected_teams
  end
end

