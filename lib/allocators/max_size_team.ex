defmodule TeamBuilder.Allocators.MaxSizeTeam do
  alias TeamBuilder.Allocators.TeamAllocator

  def assign_teams(members, max_size, seed_state) do
    team_number = 0
    members
    |> calculate_number_of_teams(0, max_size)
    |> _assign_teams(members, max_size, team_number, seed_state)
    |> TeamAllocator.separate_teams_and_seed
  end

  defp _assign_teams(0, _, _, _, seed_state), do: [%{:new_seed => seed_state}]
  defp _assign_teams(number_of_teams, members, max_size, team_number, seed_state) do
    number_of_members_to_select = number_of_members_to_select(members, max_size)
    {selection, remainder, new_seed} =
    TeamAllocator.members_selection(members, number_of_members_to_select, seed_state)
    with_team_number([selection], team_number) ++
    _assign_teams(number_of_teams - 1, remainder, max_size, team_number + 1, new_seed)
  end

  defp number_of_members_to_select([_| []], _), do: 1
  defp number_of_members_to_select(members, max_size) do
    div(Enum.count(members), calculate_number_of_teams(members, 0, max_size)) end

  defp calculate_number_of_teams([], team_count, _), do: team_count
  defp calculate_number_of_teams(members, team_count, max_size) do
    members
    |> remaining_members(max_size)
    |> calculate_number_of_teams(team_count + 1, max_size)
  end

  defp with_team_number(team, team_number) do
    team
    |> Enum.map(fn(members) -> Enum.map(members, fn(member) -> TeamAllocator.map_member_to_team(member, team_number) end) end)
    |> List.flatten
  end

  defp remaining_members(members, max_size) do
    Enum.drop(members, max_size)
  end
end
