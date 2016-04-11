defmodule Allocators.TeamAllocatorTest do
  use ExUnit.Case
  alias TeamBuilder.Allocators.TeamAllocator

  setup do
    {:ok, seed_state: :rand.export_seed_s(:rand.seed(:exsplus)) }
  end

  test "select members randomly", context do
    members = TestHelper.generate_members(4)
    selected = Enum.take_random(members, 4)
    expected = {selected, [], :rand.export_seed()}
    assert TeamAllocator.members_selection(members, 4, context[:seed_state]) == expected
  end

  test "members with the same name", context do
    members = TestHelper.generate_members(4)
    selected = Enum.take_random(members, 4)
    expected = {selected, [], :rand.export_seed()}
    assert TeamAllocator.members_selection(members, 4, context[:seed_state]) == expected
  end

  test "map a member to a team" do
    expected = %{:member => "Sarah", :team => 1}
    assert TeamAllocator.associate_member_with_team("Sarah", zero_indexed(1)) == expected
  end

  test "separate team allocations from new random_seed" do
    member1 = %{:member => "Sarah", :team => 1}
    member2 = %{:member => "Abigail", :team => 1}
    random_seed = %{:new_seed => "seed"}
    teams_and_seed = [member1, member2, random_seed]
    expected = {[member1, member2], random_seed[:new_seed]}
    assert TeamAllocator.separate_teams_and_seed(teams_and_seed) == expected
  end

  def zero_indexed(index) do
    index - 1
  end
end
