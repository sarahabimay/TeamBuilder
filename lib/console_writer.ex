defmodule TeamBuilder.ConsoleWriter do
  alias TeamBuilder.Messages

  def welcome_message(), do: IO.puts(Messages.welcome())

  def goodbye_message(), do: IO.puts(Messages.goodbye())

  def display_teams(teams) do
    teams
    |> Enum.map(fn(team) -> team_name(team) <> team_members(team) end)
    |> Enum.join("")
    |> IO.write
  end

  def clear_screen() do
    IO.ANSI.clear |> IO.write
    IO.ANSI.home |> IO.write
  end

  defp team_name(team) do
    "[ Team #{team[:team]} ]\n"
  end

  defp team_members(team) do
    team[:names]
    |> Enum.with_index
    |> Enum.map(fn({member, index})-> "[#{one_indexed(index)}] #{member}\n" end)
    |> Enum.join("")
    |> append_new_line
  end

  defp append_new_line(message), do: message <> "\n"

  defp one_indexed(index), do: index + 1
end
