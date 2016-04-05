defmodule TeamBuilder.Members do
  alias TeamBuilder.RandomTeamAllocator
  alias TeamBuilder.Teams

  def add_to_members(members, ""), do: members

  def add_to_members(members, new_member) do
    members ++ [new_member]
  end

  def combine_members(teams, new_members) do
    extract_all_members(teams) ++ new_members
  end

  def allocate_teams(team_type, all_members, seed_state) do
    {members, new_seed} = Teams.assign_team_numbers(all_members, team_type, seed_state)
    teams = Teams.create_teams(team_type, members)
    {teams, new_seed}
  end

  defp extract_all_members([]), do: []

  defp extract_all_members([%{team: _, names: names}| rest]) do
    names ++ extract_all_members(rest)
  end
end
