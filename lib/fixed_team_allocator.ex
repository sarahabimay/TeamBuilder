defmodule TeamBuilder.FixedTeamAllocator do
  alias TeamBuilder.TeamAllocator

  def assign_teams(members, team_count, seed_state) do
    _assign_teams(members, team_count, seed_state)
    |> TeamAllocator.separate_teams_and_seed
  end

  defp _assign_teams([], _, seed_state), do: [%{:new_seed => seed_state}]

  defp _assign_teams(members, team_count, seed_state) do
    {selection, remainder, new_seed} = TeamAllocator.members_selection(members, team_count, seed_state)
    with_team_number(selection) ++ _assign_teams(remainder, team_count, new_seed)
  end

  defp with_team_number(members) do
    members
    |> Enum.with_index
    |> Enum.map(fn({member, index}) -> TeamAllocator.map_member_to_team(member, index) end)
  end
end
