defmodule TeamBuilder.RandomTeamAllocator do
  def assign_teams(members, %{team_type: :fixed, options: _ } = team_type, seed_state) do
    _assign_teams(members, team_type, seed_state)
    |> separate_teams_and_seed
  end

  defp _assign_teams([], _, seed_state), do: [%{:new_seed => seed_state}]

  defp _assign_teams(members, %{team_type: :fixed, options: fixed_count} = team_type, seed_state) do
    {selection, new_seed} = random_member_selection(members, fixed_count, seed_state)
    remainder = remaining_members(selection, members)
    with_team_number(selection) ++ _assign_teams(remainder, team_type, new_seed)
  end

  defp random_member_selection(members, team_count, seed) do
    :rand.seed(seed)
    selection = Enum.take_random(members, team_count)
    {selection, :rand.export_seed()}
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

  def separate_teams_and_seed(teams_and_seed) do
    {extract(teams_and_seed, :team), extract_last_seed(teams_and_seed)}
  end

  defp extract_last_seed(teams_and_seed) do
    Enum.find_value(results, fn(x) -> x[:new_seed] end)
  end

  defp extract(mixed_list, search_atom) do
    Enum.filter(mixed_list, fn(element) -> element[search_atom] end)
  end

  defp one_indexed(zero_index), do: zero_index + 1
end
