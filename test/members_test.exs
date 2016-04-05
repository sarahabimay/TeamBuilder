defmodule MembersTest do
  use ExUnit.Case
  doctest TeamBuilder
  alias TeamBuilder.Members

  @team_type %{:team_type => :fixed, :options => 4}
  @max_size_team_type %{:team_type => :max_size, :options => 4}
  @max_size_two %{:team_type => :max_size, :options => 2}

  defmodule FakeDisplay do
    def next_command(), do: "Sarah"
  end

  test "'empty' new member not added to existing members" do
    new_member = ""
    members = ["April", "May"]
    expected = ["April", "May"]
    assert Members.add_to_members(members, new_member) == expected
  end

  test "new member added to existing members" do
    new_member = "Sarah"
    members = ["April", "May"]
    expected = ["April", "May", "Sarah"]
    assert Members.add_to_members(members, new_member) == expected
  end

  test "add new member to existing members" do
    new_member = ["Sarah"]
    teams = [
      %{:team => 1, :names => ["April"]},
      %{:team => 2, :names => ["May"]},
      %{:team => 3, :names => []},
      %{:team => 4, :names => []}
    ]
    expected = ["April", "May", "Sarah"]
    assert Members.combine_members(teams, new_member) == expected
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
    {teams, _} =  Members.allocate_teams(@team_type, [a1, a2], seed_state)
    assert teams == expected_teams
  end

  test "max team size: 2 - 4 members generates two Teams" do
    members = generate_members(4)
    seed_state = :rand.export_seed_s(:rand.seed(:exsplus))
    {teams, _} =  Members.allocate_teams(@max_size_two, members, seed_state)
    {teams_two, _} =  Members.allocate_teams(@max_size_two, members, seed_state)
    assert teams == teams_two
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
    {teams, _} = Members.allocate_teams(@team_type, all_members, seed_state)
    assert teams == expected_teams
  end

  def generate_members(number) do
    Enum.map(1..number, fn(num) -> "name#{num}" end)
  end

  def remaining_members(selected_members, all_members) do
    {_, remaining} = Enum.partition(all_members, fn(x) -> Enum.any?(selected_members, fn(s) -> s == x end) end)
    remaining
  end
end
