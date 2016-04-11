defmodule TeamBuilder.Allocators.FixedTeam do
  alias TeamBuilder.Allocators.TeamAllocator

  def assign_teams(members, team_count, seed_state) do
    team_count
    |> _assign_teams(members, seed_state)
    |> TeamAllocator.separate_teams_and_seed
  end

  defp _assign_teams(_, [], seed_state), do: [%{:new_seed => seed_state}]
  defp _assign_teams(team_count, members, seed_state) do
    {selection, remainder, new_seed} = TeamAllocator.members_selection(members, team_count, seed_state)
    assign_team_number(selection) ++ _assign_teams(team_count, remainder, new_seed)
  end

  defp assign_team_number(members) do
    members
    |> Enum.with_index
    |> Enum.map(fn({member, index}) -> TeamAllocator.associate_member_with_team(member, index) end)
  end
end
