defmodule RandomTeamAllocatorTest do
  use ExUnit.Case
  doctest TeamBuilder
  alias TeamBuilder.RandomTeamAllocator

  test "assign 4 members to 4 teams" do
    members = ["name1", "name2", "name3", "name4"]
    team_type = %{:team_type => :fixed, :options => 4 }
    seed_state = :rand.export_seed_s(:rand.seed(:exsplus))
    [a1, a2, a3, a4] = Enum.take_random(members, 4)
    expected_teams = [
      %{ :member => a1, :team => 1 },
      %{ :member => a2, :team => 2 },
      %{ :member => a3, :team => 3 },
      %{ :member => a4, :team => 4 }
    ]
    {teams, _ } = RandomTeamAllocator.assign_teams(members, team_type, seed_state)
    assert teams == expected_teams
  end

  test "max size team : assign 4 members to one team" do
    members = ["name1", "name2", "name3", "name4"]
    team_type = %{:team_type => :max_size, :options => 4 }
    seed_state = :rand.export_seed_s(:rand.seed(:exsplus))
    [a1, a2, a3, a4] = Enum.take_random(members, 4)
    expected_teams = [
      %{ :member => a1, :team => 1 },
      %{ :member => a2, :team => 1 },
      %{ :member => a3, :team => 1 },
      %{ :member => a4, :team => 1 }
    ]
    {teams, _ } = RandomTeamAllocator.assign_teams(members, team_type, seed_state)
    assert teams == expected_teams
  end

  test "max size team : max team size 4, 8 members and two teams" do
    members = generate_members(8)
    team_type = %{:team_type => :max_size, :options => 4 }
    seed_state = :rand.export_seed_s(:rand.seed(:exsplus))
    {teams, _ } = RandomTeamAllocator.assign_teams(members, team_type, seed_state)
    {teams_two, _ } = RandomTeamAllocator.assign_teams(members, team_type, seed_state)
    assert teams == teams_two
  end

  def generate_members(number) do
    Enum.map(1..number, fn(num) -> "name#{num}" end)
  end

  def remaining_members(selected_members, all_members) do
    {_, remaining} = Enum.partition(all_members, fn(x) -> Enum.any?(selected_members, fn(s) -> s == x end) end)
    remaining
  end
end
