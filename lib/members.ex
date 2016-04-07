defmodule TeamBuilder.Members do
  alias TeamBuilder.Teams

  def add_to_members(members, ""), do: members

  def add_to_members(members, new_member) do
    members ++ [new_member]
  end

  def allocate_teams(team_type, all_members, seed_state) do
    Teams.build_teams(team_type, all_members, seed_state)
  end
end
