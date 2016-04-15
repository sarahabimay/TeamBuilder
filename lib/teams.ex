defmodule TeamBuilder.Teams do
  def build_teams(team_type, all_members, random_seed) do
    team_type
    |> assign_team_numbers(all_members, random_seed)
    |> create_teams
  end

  def create_teams({members, new_seed}) do
    {add_team_members([], members), new_seed}
  end

  defp assign_team_numbers(%{team_type: _, team_allocator: allocator, options: option}, members, random_seed) do
    members
    |> allocator.assign_teams(option, random_seed)
  end

  defp add_team_members(teams, []), do: teams
  defp add_team_members(teams, [new_member | rest]) do
    amend_teams(teams, new_member)
    |> add_team_members(rest)
  end

  defp amend_teams(teams, member) do
    teams
    |> find_team(member)
    |> update_team(teams, member)
  end

  defp find_team(teams, %{member: _, team: team_number}) do
    Enum.find_index(teams, fn(team) -> team[:team] == team_number end)
  end

  defp update_team(nil, teams, %{member: new_member, team: team_number}) do
    teams ++ [update_member_list(team_skeleton(team_number), new_member)]
  end

  defp update_team(team_index, teams, %{member: new_member, team: _}) do
    List.update_at(teams, team_index, fn(team) -> update_member_list(team, new_member) end)
  end

  defp update_member_list(team, new_member) do
    Map.update!(team, :names, fn(members) -> members ++ [new_member] end)
  end

  defp team_skeleton(team_number), do: %{:team => team_number, :names => []}
end
