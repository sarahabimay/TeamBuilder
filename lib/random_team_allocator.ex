defmodule TeamBuilder.RandomTeamAllocator do
  def assign_teams([], _, _), do: []

  def assign_teams(members, %{team_type: :fixed, options: fixed_count} = team_type, random_seed_state) do
    {selection, remainder} = member_selection(members, fixed_count, random_seed_state)
    with_team_number(selection) ++ assign_teams(remainder, team_type, random_seed_state)
  end

  defp member_selection(members, team_count, random_seed_state) do
    members
    |> take_random(team_count, random_seed_state)
    |> partition(members)
  end

  defp take_random(members, team_count, random_seed_state) do
    :rand.seed(random_seed_state)
    Enum.take_random(members, team_count)
  end

  defp partition(selected_members, all_members) do
    remaining_members = remaining_members(selected_members, all_members)
    {selected_members, remaining_members}
  end

  defp remaining_members(selected_members, all_members) do
    {_, remaining} = Enum.partition(all_members, fn(x) -> Enum.any?(selected_members, fn(s) -> s == x end) end)
     remaining
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
