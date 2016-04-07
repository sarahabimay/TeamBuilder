defmodule TeamAllocatorTest do
  use ExUnit.Case
  doctest TeamBuilder
  alias TeamBuilder.TeamAllocator

  test "select 4 members randomly" do
    number_of_members = 4
    members = TestHelper.generate_members(number_of_members)
    seed_state = :rand.export_seed_s(:rand.seed(:exsplus))
    selected = Enum.take_random(members, number_of_members)
    expected = {selected, TestHelper.remaining_members(selected, members), :rand.export_seed()}
    assert TeamAllocator.members_selection(members, number_of_members, seed_state) == expected
  end

  test "select 4 members with the same name" do
    number_of_members = 4
    members = ["Sarah", "Sarah", "Sarah", "Sarah"]
    seed_state = :rand.export_seed_s(:rand.seed(:exsplus))
    selected = Enum.take_random(members, number_of_members)
    expected = {selected, TestHelper.remaining_members(selected, members), :rand.export_seed()}
    assert TeamAllocator.members_selection(members, number_of_members, seed_state) == expected
  end

  test "map a member to a team" do
    member = "Sarah"
    team = 1
    expected = %{:member => member, :team => team}
    index = 0
    assert TeamAllocator.map_member_to_team(member, index) == expected
  end

  test "separate team allocations from new random_seed" do
    member1 = %{:member => "Sarah", :team => 1}
    member2 = %{:member => "Abigail", :team => 1}
    random_seed = %{:new_seed => "seed"}
    teams_and_seed = [member1, member2, random_seed]
    expected = {[member1, member2], random_seed[:new_seed]}
    assert TeamAllocator.separate_teams_and_seed(teams_and_seed) == expected
  end
end
