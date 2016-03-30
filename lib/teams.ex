defmodule TeamBuilder.Teams do
  def empty_teams(%{team_type: :fixed, options: fixed_count}) do
    Enum.map(1..fixed_count, fn(number) -> team_skeleton(number) end)
  end

  def allocate_members(team_type, all_members, team_allocator) do
    assign_team_numbers(all_members, team_type, team_allocator)
    |> create_teams(team_type)
  end

  defp assign_team_numbers(all_members, team_type, team_allocator) do
    all_members
    |> team_allocator.(team_type)
  end

  defp create_teams(members, team_type) do
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
