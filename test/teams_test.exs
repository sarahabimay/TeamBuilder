defmodule TeamTest do
  use ExUnit.Case
  doctest TeamBuilder
  alias TeamBuilder.Teams

  @fixed_team_type %{:team_type => :fixed, :options => 4}
  @max_size_team_type %{:team_type => :max_size, :options => 4}
  @max_size_two %{:team_type => :max_size, :options => 2}

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

  test "fixed team type: one member generates one Teams from seed" do
    [new_member] = generate_members(1)
    expected_teams = [
              %{:team => 1, :names => [new_member]},
              %{:team => 2, :names => []},
              %{:team => 3, :names => []},
              %{:team => 4, :names => []}
            ]
    teams =  Teams.create_teams(@fixed_team_type, [%{member: new_member, team: 1}])
    assert teams == expected_teams
  end

  test "max size team type: one member generates one Teams from seed" do
    [new_member] = generate_members(1)
    expected_teams = [%{:team => 1, :names => [new_member]}]
    teams =  Teams.create_teams(@max_size_team_type, [%{member: new_member, team: 1}])
    assert teams == expected_teams
  end

  test "max team size:4, add two members to same team" do
    [a1, a2] = generate_members(2)
    members = [%{member: a1, team: 1}, %{member: a2, team: 1}]
    expected_teams = [%{:team => 1, :names => [a1, a2]}]
    teams =  Teams.create_teams(@max_size_team_type, members)
    assert teams == expected_teams
  end

  test "fixed teams: 4 members generates 4 Teams with 2 members each" do
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

  test "max team size:4, 5 members in 2 Teams" do
    [a1, a2, a3, a4, a5] = generate_members(5)
    members = [
      %{member: a1, team: 1},
      %{member: a2, team: 1},
      %{member: a3, team: 1},
      %{member: a4, team: 1},
      %{member: a5, team: 2}
    ]
    expected_teams = [
              %{:team => 1, :names => [a1, a2, a3, a4]},
              %{:team => 2, :names => [a5]}
            ]
    teams =  Teams.create_teams(@max_size_team_type, members)
    assert teams == expected_teams
  end

  test "max team size:2, 3 members in 2 Teams" do
    [a1, a2, a3] = generate_members(3)
    members = [
      %{member: a1, team: 1},
      %{member: a2, team: 1},
      %{member: a3, team: 2}
    ]
    expected_teams = [
              %{:team => 1, :names => [a1, a2]},
              %{:team => 2, :names => [a3]}
            ]
    teams =  Teams.create_teams(@max_size_two, members)
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
end
