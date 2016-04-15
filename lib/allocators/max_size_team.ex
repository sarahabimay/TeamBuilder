defmodule TeamBuilder.Allocators.MaxSizeTeam do
  alias TeamBuilder.Allocators.TeamAllocator

  def assign_teams(members, max_size, seed_state) do
    members
    |> calculate_number_of_teams(0, max_size)
    |> _assign_teams(members, max_size, seed_state)
    |> TeamAllocator.separate_teams_and_seed
  end

  defp _assign_teams(0, _, _, seed_state), do: [%{:new_seed => seed_state}]
  defp _assign_teams(team_count, members, max_size, seed_state) do
    {selection, remainder, new_seed} = select_members(members, max_size, seed_state)
    assign_team_number(selection, team_count - 1 ) ++
    _assign_teams(team_count - 1, remainder, max_size, new_seed)
  end

  defp select_members(members, max_size, seed_state) do
    number_of_members = number_of_members_to_select(members, max_size)
    TeamAllocator.members_selection(members, number_of_members, seed_state)
  end

  defp number_of_members_to_select([_| []], _), do: 1
  defp number_of_members_to_select(members, max_size) do
    div(Enum.count(members), calculate_number_of_teams(members, 0, max_size))
  end

  defp calculate_number_of_teams([], team_count, _), do: team_count
  defp calculate_number_of_teams(members, team_count, max_size) do
    members
    |> remaining_members(max_size)
    |> calculate_number_of_teams(team_count + 1, max_size)
  end

  defp assign_team_number(team_members, team_number) do
    team_members
    |> Enum.map(fn(member) -> TeamAllocator.associate_member_with_team(member, team_number) end)
  end

  defp remaining_members(members, max_size) do
    Enum.drop(members, max_size)
  end
end
