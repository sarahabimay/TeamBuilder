defmodule TeamBuilder.MaxSizeTeamAllocator do
  alias TeamBuilder.TeamAllocator

  def assign_teams(members, max_size, seed_state) do
    team_number = 0
    _assign_teams(members, max_size, team_number, seed_state)
    |> TeamAllocator.separate_teams_and_seed
  end

  defp _assign_teams([], _, _, seed_state), do: [%{:new_seed => seed_state}]

  defp _assign_teams(members, max_size, team_number, seed_state) do
    {selection, remainder, new_seed} = TeamAllocator.members_selection(members, max_size, seed_state)
    with_team_number(selection, team_number) ++ _assign_teams(remainder, max_size, team_number + 1, new_seed)
  end

  defp with_team_number(members, team_number) do
    members
    |> Enum.map(fn(member) -> TeamAllocator.map_member_to_team(member, team_number) end)
  end
end
