defmodule TeamBuilder.Teams do
  alias TeamBuilder.RandomTeamAllocator

  def empty_teams(%{team_type: :fixed, options: fixed_count}) do
    Enum.map(1..fixed_count, fn(number) -> team_skeleton(number) end)
  end

  def empty_teams(%{team_type: :max_size, options: _}) do
    Enum.map(1..1, fn(number) -> team_skeleton(number) end)
  end

  def assign_team_numbers(all_members, team_type, random_seed) do
    all_members
    |> RandomTeamAllocator.assign_teams(team_type, random_seed)
  end

  def create_teams(%{team_type: :max_size, options: _}, members) do
    add_team_members([], :max_size, members)
  end

  def create_teams(team_type, members) do
    team_type
    |> empty_teams
    |> add_team_members(members)
  end

  def add_team_members(teams, :max_size, []), do: teams

  def add_team_members(teams, :max_size, [new_member | rest]) do
    ammend_teams(teams, new_member)
    |> add_team_members(:max_size, rest)
  end

  def ammend_teams(teams, %{member: _, team: team_number} = member) do
    new_teams =
    if Enum.at(teams, zero_indexed(team_number), :none) == :none do
      add_new_team(teams, team_number)
    else
      teams
    end
    update_team(new_teams, member)
  end

  defp add_new_team(teams, team_number) do
    List.insert_at(teams, zero_indexed(team_number), team_skeleton(team_number))
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
