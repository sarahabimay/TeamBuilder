defmodule TeamBuilder.Console do
  alias TeamBuilder.ConsoleReader
  alias TeamBuilder.ConsoleWriter

  def next_command() do
    ConsoleReader.next_command()
  end

  def team_type_options() do
    ConsoleWriter.clear_screen()
    ConsoleReader.team_type_options()
  end

  def welcome_message() do
    ConsoleWriter.clear_screen()
    ConsoleWriter.welcome_message()
  end

  def goodbye_message(), do: ConsoleWriter.goodbye_message()

  def display_members(members), do: ConsoleWriter.display_members(members)

  def display_teams(teams), do: ConsoleWriter.display_teams(teams)

  def clear_screen(), do: ConsoleWriter.clear_screen()
end
