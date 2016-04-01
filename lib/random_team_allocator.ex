defmodule TeamBuilder.RandomTeamAllocator do
  def assign_teams(members, %{team_type: :fixed, options: fixed_count} = team_type, seed_state) do
    teams = _assign_teams(members, team_type, seed_state)
    {teams, :rand.export_seed()}
  end

  defp _assign_teams([], _, seed_state), do: []

  defp _assign_teams(members, %{team_type: :fixed, options: fixed_count} = team_type, seed_state) do
    {selection, remainder} = member_selection(members, fixed_count, seed_state)
    with_team_number(selection) ++ _assign_teams(remainder, team_type, seed_state)
  end

  defp member_selection(members, team_count, seed) do
    members
    |> take_random_pure(team_count, seed)
    |> partition(members)
  end

  defp take_random_pure(members, team_count, seed) do
    :rand.seed(seed)
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
