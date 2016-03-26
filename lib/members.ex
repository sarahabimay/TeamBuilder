defmodule TeamBuilder.Members do
  def combine_members(teams, new_members) do
    extract_all_members(teams) ++ new_members
  end

  def next_instruction(display_reader) do
    display_reader.add_members()
    |> parse_input
  end

  defp parse_input("q"), do: :quit

  defp parse_input(input) do
    [input]
  end

  defp extract_all_members([]), do: []

  defp extract_all_members([%{team: _, names: names}| rest]) do
    names ++ extract_all_members(rest)
  end
end
