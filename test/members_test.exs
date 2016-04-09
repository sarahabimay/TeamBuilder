defmodule MembersTest do
  use ExUnit.Case
  alias TeamBuilder.Members
  alias TeamBuilder.Allocators.FixedTeam
  alias TeamBuilder.Allocators.MaxSizeTeam

  setup do
    {:ok,
     seed_state: :rand.export_seed_s(:rand.seed(:exsplus)),
     fixed_team_type: %{:team_type => :fixed, :team_allocator => FixedTeam, :options => 4},
     max_size_two: %{:team_type => :max_size, :team_allocator => MaxSizeTeam, :options => 2}
   }
  end

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

  test "fixed number of teams generated", context do
    members = TestHelper.generate_members(2)
    [first, second] = Enum.take_random(members, 4)
    expected_teams = [
      %{:team => 1, :names => [first]},
      %{:team => 2, :names => [second]},
    ]
    {teams, _} =  Members.allocate_teams(context[:fixed_team_type], members, context[:seed_state])
    assert teams == expected_teams
  end

  test "generates max member sized teams", context  do
    members = TestHelper.generate_members(4)
    {teams, _} =  Members.allocate_teams(context[:max_size_two], members, context[:seed_state])
    {teams_two, _} =  Members.allocate_teams(context[:max_size_two], members, context[:seed_state])
    assert teams == teams_two
  end
end
