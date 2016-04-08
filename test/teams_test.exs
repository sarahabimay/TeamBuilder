defmodule TeamTest do
  use ExUnit.Case
  alias TeamBuilder.Teams
  alias TeamBuilder.Allocators.FixedTeam
  alias TeamBuilder.Allocators.MaxSizeTeam

  setup do
    {
      :ok,
      fixed_team_type: %{:team_type => :fixed, :team_allocator => FixedTeam, :options => 4},
      max_size_team_type: %{:team_type => :max_size, :team_allocator => MaxSizeTeam, :options => 4},
      random_seed: :rand.export_seed_s(:rand.seed(:exsplus))
    }
  end

  test "assign members to fixed number teams", context do
    members = TestHelper.generate_members(5)
    [a1, a2, a3, a4] = Enum.take_random(members, 4)
    [a5] = TestHelper.remaining_members([a1, a2, a3, a4], members)
    expected_teams = [
      %{:team => 1, :names => [a1, a5]},
      %{:team => 2, :names => [a2]},
      %{:team => 3, :names => [a3]},
      %{:team => 4, :names => [a4]}
    ]
    {teams, _} = Teams.build_teams(context[:fixed_team_type], members, context[:random_seed])
    assert teams == expected_teams
  end

  test "assign members to max sized teams", context do
    members = TestHelper.generate_members(5)
    {teams, _} = Teams.build_teams(context[:max_size_team_type], members, context[:random_seed])
    {teams_two, _} = Teams.build_teams(context[:max_size_team_type], members, context[:random_seed])
    assert teams == teams_two
  end

  test "fixed_team_count:4 one member generates one team" do
    [a1] = TestHelper.generate_members(1)
    expected_teams = [ %{:team => 1, :names => [a1]}]
    teams =  Teams.create_teams([%{member: a1, team: 1}])
    assert teams == expected_teams
  end

  test "max_size_team:4 one member generates one team" do
    [a1] = TestHelper.generate_members(1)
    expected_teams = [ %{:team => 1, :names => [a1]} ]
    teams =  Teams.create_teams([%{member: a1, team: 1}])
    assert teams == expected_teams
  end

  test "max_team_size:4, four members added to same team" do
    [a1, a2, a3, a4] = TestHelper.generate_members(4)
    members = [
      %{member: a1, team: 1},
      %{member: a2, team: 1},
      %{member: a3, team: 1},
      %{member: a4, team: 1}
    ]
    expected_teams = [%{ :team => 1, :names => [a1, a2, a3, a4]}]
    assert Teams.create_teams( members) == expected_teams
  end

  test "fixed_team_count:4, 4 members generates 4 Teams" do
    [a1, a2, a3, a4] = TestHelper.generate_members(4)
    members = [
      %{member: a1, team: 1},
      %{member: a2, team: 2},
      %{member: a3, team: 3},
      %{member: a4, team: 4}
    ]
    expected_teams = [
      %{:team => 1, :names => [a1]},
      %{:team => 2, :names => [a2]},
      %{:team => 3, :names => [a3]},
      %{:team => 4, :names => [a4]}
    ]
    assert Teams.create_teams(members) == expected_teams
  end
end
