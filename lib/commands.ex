defmodule TeamBuilder.Commands  do
  def translate_command("q"), do: :quit
  def translate_command("b"), do: :build_teams
  def translate_command(command), do: command
end
