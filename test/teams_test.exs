defmodule TeamTest do
  use ExUnit.Case
  doctest TeamBuilder
  alias TeamBuilder.Teams

  @team_type %{:team_type => :fixed, :options => 4}

  test "fixed number of teams created" do
    fixed_number_of_teams = 4
    expected_result = get_teams(fixed_number_of_teams)
    assert Teams.empty_teams(@team_type) == expected_result
  end

  test "two members generates two Teams from seed" do
    [a1, a2] = generate_members(2)
    seed_state = :rand.export_seed_s(:rand.seed(:exsplus))
    [first, second] = Enum.take_random([a1, a2], 4)
    expected_teams = [
              %{:team => 1, :names => [first]},
              %{:team => 2, :names => [second]},
              %{:team => 3, :names => []},
              %{:team => 4, :names => []}
            ]
    {teams, _} =  Teams.allocate_members(@team_type, [a1, a2], seed_state)
    assert teams == expected_teams
  end

  test "eight members generates 4 Teams with 2 members each" do
    all_members = generate_members(4)
    seed_state = :rand.export_seed_s(:rand.seed(:exsplus))
    [a1, a2, a3, a4] = Enum.take_random(all_members, 4)
    expected_teams = [
              %{:team => 1, :names => [a1] },
              %{:team => 2, :names => [a2] },
              %{:team => 3, :names => [a3] },
              %{:team => 4, :names => [a4] }
            ]
    {teams, _} =  Teams.allocate_members(@team_type, all_members, seed_state)
    assert teams == expected_teams
  end

  def generate_members(number) do
    Enum.map(1..number, fn(num) -> "name#{num}" end)
  end

  def get_teams(number) when number == 4 do
    [
      %{:team => 1, :names => []},
      %{:team => 2, :names => []},
      %{:team => 3, :names => []},
      %{:team => 4, :names => []},
    ]
  end
end
