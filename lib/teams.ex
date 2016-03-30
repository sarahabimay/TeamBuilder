defmodule TeamBuilder.Teams do
  def empty_teams(%{team_type: :fixed, options: fixed_count}) do
    Enum.map(1..fixed_count, fn(number) -> team_skeleton(number) end)
  end

  def allocate_members(team_type, all_members, team_allocator) do
    team_type
    |> empty_teams
    |> _allocate_members(team_type, all_members, team_allocator)
  end

  defp _allocate_members(teams, team_type, all_members, team_allocator) do
    all_members
    |> team_allocator.(team_type)
    |> add_members(teams)
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
end
