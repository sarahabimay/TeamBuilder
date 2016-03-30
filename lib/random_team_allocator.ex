defmodule TeamBuilder.RandomTeamAllocator do
  def team_allocator(member_selector) do
    fn(members, team_type) ->
      assign_teams(members, team_type, member_selector)
    end
  end

  def assign_teams([], _, _), do: []

  def assign_teams(members, %{team_type: :fixed, options: fixed_count} = team_type, member_selector) do
    {selection, remainder} = member_selection(members, fixed_count, member_selector)
    with_team_number(selection) ++ assign_teams(remainder, team_type, member_selector)
  end

  defp member_selection(members, team_count, member_selector) do
    members
    |> member_selector.take_random(team_count)
    |> partition(members)
  end

  defp partition(selected_members, all_members) do
    all_members
    |> Enum.partition(fn(x) -> Enum.any?(selected_members, fn(s) -> s == x end) end)
  end

  defp with_team_number(members) do
    members
    |> Enum.with_index
    |> Enum.map(fn({member, index}) -> map_member_to_team(member, index) end)
  end

  defp map_member_to_team(member, index) do
    %{ :member => member, :team => one_indexed(index) }
  end

  defp one_indexed(zero_index), do: zero_index + 1
end
