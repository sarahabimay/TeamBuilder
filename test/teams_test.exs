defmodule TeamTest do
  use ExUnit.Case
  doctest TeamBuilder
  alias TeamBuilder.Teams

  defmodule FakeRandomSelection do
    def take_random(members, count) do
      Enum.take(members, count)
    end
  end

  @team_type %{:team_type => :fixed, :options => 4}

  test "fixed number of teams created" do
    fixed_number_of_teams = 4
    expected_result = get_teams(fixed_number_of_teams)
    assert Teams.empty_teams(@team_type) == expected_result
  end

  test "two members generates two Teams" do
    [a1, a2] = generate_members(2)
    team_allocator = TeamBuilder.RandomTeamAllocator.team_allocator(FakeRandomSelection)
    expected_result = [
              %{:team => 1, :names => [a1]},
              %{:team => 2, :names => [a2]},
              %{:team => 3, :names => []},
              %{:team => 4, :names => []}
            ]
    assert Teams.allocate_members(@team_type, [a1, a2], team_allocator) == expected_result
  end

  test "eight members generates 4 Teams with 2 members each" do
    all_members = generate_members(8)
    [a1, a2, a3, a4, a5, a6, a7, a8] = all_members
    team_allocator = TeamBuilder.RandomTeamAllocator.team_allocator(FakeRandomSelection)
    expected_result = [
              %{:team => 1, :names => [a1, a5] },
              %{:team => 2, :names => [a2, a6] },
              %{:team => 3, :names => [a3, a7] },
              %{:team => 4, :names => [a4, a8] }
            ]
    assert Teams.allocate_members(@team_type, all_members, team_allocator) == expected_result
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
