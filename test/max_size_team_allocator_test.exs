defmodule MaxSizeTeamAllocatorTest do
  use ExUnit.Case
  doctest TeamBuilder
  alias TeamBuilder.MaxSizeTeamAllocator

  test "max_size_team:4 assign 4 members to one team" do
    members = ["name1", "name2", "name3", "name4"]
    max_size = 4
    team_type = %{:team_type => :max_size, :options => max_size }
    seed_state = :rand.export_seed_s(:rand.seed(:exsplus))
    [a1, a2, a3, a4] = Enum.take_random(members, max_size)
    expected_teams = [
      %{ :member => a1, :team => 1 },
      %{ :member => a2, :team => 1 },
      %{ :member => a3, :team => 1 },
      %{ :member => a4, :team => 1 }
    ]
    {teams, _ } = MaxSizeTeamAllocator.assign_teams(members, team_type, seed_state)
    assert teams == expected_teams
  end

  test "max_size_team:4 - 8 members and two teams" do
    members = generate_members(8)
    team_type = %{:team_type => :max_size, :options => 4 }
    seed_state = :rand.export_seed_s(:rand.seed(:exsplus))
    {teams, _ } = MaxSizeTeamAllocator.assign_teams(members, team_type, seed_state)
    {teams_two, _ } = MaxSizeTeamAllocator.assign_teams(members, team_type, seed_state)
    assert teams == teams_two
  end

  def generate_members(number) do
    Enum.map(1..number, fn(num) -> "name#{num}" end)
  end
end
