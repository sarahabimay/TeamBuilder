defmodule TeamBuilder.Team do
  def empty_teams(%{team_type: :fixed, options: fixed_count}) do
    Enum.map(1..fixed_count, fn(number) -> team_skeleton(number) end)
  end

  def allocate_members(team_type, all_members) do
    team_type
    |> empty_teams
    |> _allocate_members(all_members)
  end

  defp _allocate_members(teams, all_members) do
    teams
    |> assign_team_numbers(all_members)
    |> add_members(teams)
  end

  defp assign_team_numbers(teams, members) do
    members
    |> Enum.with_index
    |> Enum.map(fn({member, index}) -> map_member_to_team(member, index, teams) end)
  end

  defp map_member_to_team(member, index, teams) do
    %{:member => member, :team => get_team(index, teams)}
  end

  defp get_team(index, teams) do
    teams
    |> Enum.count
    |> get_team_number(one_indexed(index))
  end

  defp get_team_number(max_team_number, member_number) when member_number <= max_team_number do
    member_number
  end

  defp get_team_number(max_team_number, member_number) do
    remainder = rem(member_number, max_team_number)
    if remainder == 0, do: max_team_number, else: remainder
  end

  defp add_members([], teams), do: teams

  defp add_members([member | rest], teams) do
    modified_teams = add_member(member, teams)
    add_members(rest, modified_teams)
  end

  defp add_member(member, teams) do
    member_name = member[:member]
    team_number = member[:team]
    update_team(teams, team_number, member_name)
  end

  defp update_team(teams, team_number, new_member) do
    List.update_at(teams, team_number - 1, fn(team) -> update_member_list(team, new_member) end)
  end

  defp update_member_list(team, new_member) do
    Map.update!(team, :names, fn(members) -> members ++ [new_member] end)
  end

  defp team_skeleton(team_number), do: %{:team => team_number, :names => []}

  defp one_indexed(zero_index), do: zero_index + 1
end
