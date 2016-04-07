defmodule FixedTeamTest do
  use ExUnit.Case
  doctest TeamBuilder
  alias TeamBuilder.FixedTeam

  test "fixed_team_count:4 assign 4 members to 4 teams" do
    members = ["name1", "name2", "name3", "name4"]
    team_count = 4
    seed_state = :rand.export_seed_s(:rand.seed(:exsplus))
    [a1, a2, a3, a4] = Enum.take_random(members, 4)
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

