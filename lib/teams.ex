defmodule TeamBuilder.Teams do
  alias TeamBuilder.RandomTeamAllocator

  def empty_teams(%{team_type: :fixed, options: fixed_count}) do
    Enum.map(1..fixed_count, fn(number) -> team_skeleton(number) end)
  end

  def allocate_members(team_type, all_members, random_seed) do
    {members, new_seed} = assign_team_numbers(all_members, team_type, random_seed)
    teams = create_teams(team_type, members)
    {teams, new_seed}
  end

  defp assign_team_numbers(all_members, team_type, random_seed) do
    all_members
    |> RandomTeamAllocator.assign_teams(team_type, random_seed)
  end

  defp create_teams(team_type, members) do
    team_type
    |> empty_teams
    |> add_team_members(members)
  end

  defp add_team_members(teams, []), do: teams

  defp add_team_members(teams, [new_member | rest]) do
    teams
    |> update_team(new_member)
    |> add_team_members(rest)
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
