defmodule TeamBuilder.Members do
  def next_member(display_reader) do
    display_reader.next_command()
    |> parse_input
  end

  def add_to_members(members, new_member) do
    members ++ [new_member]
  end

  def combine_members(teams, new_members) do
    extract_all_members(teams) ++ new_members
  end

  defp parse_input(input) do
    [input]
  end

  defp extract_all_members([]), do: []

  defp extract_all_members([%{team: _, names: names}| rest]) do
    names ++ extract_all_members(rest)
  end
end
