defmodule TeamBuilder.Commands  do
  def command_type("q"), do: :quit
  def command_type("b"), do: :build_teams
  def command_type(command), do: {:add_member, command}
end
