defmodule TeamBuilder.TeamAllocator do
  def members_selection(members, size, seed_state) do
    {selection, new_seed} = random_member_selection(members, size, seed_state)
    remainder = remaining_members(selection, members)
    {selection, remainder, new_seed}
  end

  def map_member_to_team(member, index) do
    %{ :member => member, :team => one_indexed(index) }
  end

  def separate_teams_and_seed(teams_and_seed) do
    {extract(teams_and_seed, :team), extract_last_seed(teams_and_seed)}
  end

  defp random_member_selection(members, team_count, seed) do
    :rand.seed(seed)
    selection = Enum.take_random(members, team_count)
    {selection, :rand.export_seed()}
  end

  defp extract_last_seed(teams_and_seed) do
    Enum.find_value(teams_and_seed, fn(x) -> x[:new_seed] end)
  end

  defp extract(mixed_list, search_atom) do
    Enum.filter(mixed_list, fn(element) -> element[search_atom] end)
  end

  defp remaining_members(selected_members, all_members) do
    {_, remaining} = Enum.partition(all_members, fn(x) -> Enum.any?(selected_members, fn(s) -> s == x end) end)
    remaining
  end

  defp one_indexed(zero_index), do: zero_index + 1
end
