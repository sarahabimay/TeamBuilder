defmodule TeamTest do
  use ExUnit.Case
  doctest TeamBuilder
  alias TeamBuilder.Teams
  alias TeamBuilder.FixedTeamAllocator
  alias TeamBuilder.MaxSizeTeamAllocator

  @fixed_team_type %{:team_type => :fixed, :team_allocator => FixedTeamAllocator, :options => 4}
  @max_size_team_type %{:team_type => :max_size, :team_allocator => MaxSizeTeamAllocator, :options => 4}

  test "fixed number of teams created" do
    fixed_number_of_teams = 4
    expected_result = get_teams(fixed_number_of_teams)
    assert Teams.empty_teams(@fixed_team_type) == expected_result
  end

  test "max team size empty team created" do
    expected_result = [
      %{:team => 1, :names => []}
    ]
    assert Teams.empty_teams(@max_size_team_type) == expected_result
  end

  test "fixed_team_count:4 - assign 5 members to 4 teams" do
    members = generate_members(5)
    random_seed = :rand.export_seed_s(:rand.seed(:exsplus))
    [a1, a2, a3, a4] = Enum.take_random(members, 4)
    [a5] = remaining_members([a1, a2, a3, a4], members)
    expected_teams = [
      %{:team => 1, :names => [a1, a5] },
      %{:team => 2, :names => [a2] },
      %{:team => 3, :names => [a3] },
      %{:team => 4, :names => [a4] }
    ]
    {teams, _} = Teams.build_teams(@fixed_team_type, members, random_seed)
    assert teams == expected_teams
  end

  test "max_size_team:4 - assign 5 members to 2 teams" do
    members = generate_members(5)
    random_seed = :rand.export_seed_s(:rand.seed(:exsplus))
    [a1, a2, a3, a4] = Enum.take_random(members, 4)
    [a5] = remaining_members([a1, a2, a3, a4], members)
    expected_teams = [
      %{:team => 1, :names => [a1, a2, a3, a4] },
      %{:team => 2, :names => [a5] }
    ]
    {teams, _} = Teams.build_teams(@max_size_team_type, members, random_seed)
    assert teams == expected_teams
  end

  test "fixed_team_count:4 one member generates one team" do
    [a1] = generate_members(1)
    expected_teams = [
      %{:team => 1, :names => [a1]},
      %{:team => 2, :names => []},
      %{:team => 3, :names => []},
      %{:team => 4, :names => []}
    ]
    teams =  Teams.create_teams(@fixed_team_type, [%{member: a1, team: 1}])
    assert teams == expected_teams
  end

  test "max_size_team:4 one member generates one team" do
    [a1] = generate_members(1)
    expected_teams = [
      %{:team => 1, :names => [a1]}
    ]
    teams =  Teams.create_teams(@max_size_team_type, [%{member: a1, team: 1}])
    assert teams == expected_teams
  end

  test "max_team_size:4, four members added to same team" do
    [a1, a2, a3, a4] = generate_members(4)
    members = [
      %{member: a1, team: 1},
      %{member: a2, team: 1},
      %{member: a3, team: 1},
      %{member: a4, team: 1}
    ]
    expected_teams = [
      %{ :team => 1, :names => [a1, a2, a3, a4]}
    ]
    teams =  Teams.create_teams(@max_size_team_type, members)
    assert teams == expected_teams
  end

  test "fixed_team_count:4, 4 members generates 4 Teams" do
    [a1, a2, a3, a4] = generate_members(4)
    members = [
      %{member: a1, team: 1},
      %{member: a2, team: 2},
      %{member: a3, team: 3},
      %{member: a4, team: 4}
    ]
    expected_teams = [
      %{:team => 1, :names => [a1] },
      %{:team => 2, :names => [a2] },
      %{:team => 3, :names => [a3] },
      %{:team => 4, :names => [a4] }
    ]
    teams =  Teams.create_teams(@fixed_team_type, members)
    assert teams == expected_teams
  end

  def generate_members(number) do
    Enum.map(1..number, fn(num) -> "name#{num}" end)
  end

  def get_teams(0) do
    [
      %{:team => 1, :names => []},
    ]
  end

  def get_teams(4) do
    [
      %{:team => 1, :names => []},
      %{:team => 2, :names => []},
      %{:team => 3, :names => []},
      %{:team => 4, :names => []},
    ]
  end

  def remaining_members(selected_members, all_members) do
    {_, remaining} = Enum.partition(all_members, fn(x) -> Enum.any?(selected_members, fn(s) -> s == x end) end)
    remaining
  end
end
