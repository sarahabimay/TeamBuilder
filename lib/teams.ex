defmodule TeamBuilder.Teams do
  def build_teams(team_type, all_members, random_seed) do
    {members, new_seed} = assign_team_numbers(team_type, all_members, random_seed)
    teams = create_teams(members)
    {teams, new_seed}
  end

  defp assign_team_numbers(%{team_type: _, team_allocator: allocator, options: option}, members, random_seed) do
    members
    |> allocator.assign_teams(option, random_seed)
  end

  def create_teams(members), do: add_team_members([], members)

  defp add_team_members(teams, []), do: teams
  defp add_team_members(teams, [new_member | rest]) do
    amend_teams(teams, new_member)
    |> add_team_members(rest)
  end

  defp amend_teams(teams, %{member: _, team: team_number} = member) do
    teams
    |> create_new_team(team_number)
    |> update_team(member)
  end

  defp create_new_team(teams, team_number) do
    if not existing_team?(teams, team_number), do: add_new_team(teams, team_number), else: teams
  end

  defp existing_team?(teams, team_number) do
    Enum.at(teams, zero_indexed(team_number), :none) != :none
  end

  defp add_new_team(teams, team_number) do
    List.insert_at(teams, zero_indexed(team_number), team_skeleton(team_number))
  end

  defp update_team(teams, %{member: new_member, team: team_number}) do
    List.update_at(teams, zero_indexed(team_number), fn(team) -> update_member_list(team, new_member) end)
  end

  defp update_member_list(team, new_member) do
    Map.update!(team, :names, fn(members) -> members ++ [new_member] end)
  end

  defp team_skeleton(team_number), do: %{:team => team_number, :names => []}

  defp zero_indexed(number), do: number - 1
end
