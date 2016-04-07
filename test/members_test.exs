defmodule MembersTest do
  use ExUnit.Case
  doctest TeamBuilder
  alias TeamBuilder.Members
  alias TeamBuilder.FixedTeam
  alias TeamBuilder.MaxSizeTeam

  @fixed_team_type %{:team_type => :fixed, :team_allocator => FixedTeam, :options => 4}
  @max_size_two %{:team_type => :max_size, :team_allocator => MaxSizeTeam, :options => 2}

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

  test "fixed_team_count:4 two members generates two Teams from seed" do
    [a1, a2] = TestHelper.generate_members(2)
    seed_state = :rand.export_seed_s(:rand.seed(:exsplus))
    [first, second] = Enum.take_random([a1, a2], 4)
    expected_teams = [
              %{:team => 1, :names => [first]},
              %{:team => 2, :names => [second]},
            ]
    {teams, _} =  Members.allocate_teams(@fixed_team_type, [a1, a2], seed_state)
    assert teams == expected_teams
  end

  test "max_team_size:2 - 4 members generates two Teams" do
    members = TestHelper.generate_members(4)
    seed_state = :rand.export_seed_s(:rand.seed(:exsplus))
    {teams, _} =  Members.allocate_teams(@max_size_two, members, seed_state)
    {teams_two, _} =  Members.allocate_teams(@max_size_two, members, seed_state)
    assert teams == teams_two
  end
end
