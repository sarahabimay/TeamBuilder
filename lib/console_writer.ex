defmodule TeamBuilder.ConsoleWriter do
  alias TeamBuilder.Messages

  def welcome_message(), do: IO.puts(Messages.welcome())

  def goodbye_message(), do: IO.puts(Messages.goodbye())

  def display_members(members) do
    IO.write members_header() <> team_members(members)
  end

  def display_teams(teams) do
    teams
    |> Enum.map(fn(team) -> team_name(team) <> team_members(team[:names]) end)
    |> Enum.join("")
    |> IO.write
  end

  def clear_screen() do
    IO.ANSI.clear |> IO.write
    IO.ANSI.home |> IO.write
  end

  defp members_header() do
    Messages.members_header()
    |> append_new_line
  end

  defp team_name(team) do
    Messages.team_table_header(team[:team])
    |> append_new_line
  end

  defp team_members(members) do
    members
    |> Enum.with_index
    |> Enum.map(fn({member, index})-> "[#{one_indexed(index)}] #{member}\n" end)
    |> Enum.join("")
    |> append_new_line
  end

  defp append_new_line(message), do: message <> "\n"

  defp one_indexed(index), do: index + 1
end
