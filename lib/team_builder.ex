defmodule TeamBuilder do
  alias TeamBuilder.Members
  alias TeamBuilder.ConsoleWriter
  alias TeamBuilder.ConsoleReader
  alias TeamBuilder.Team

  def main(_) do
    ConsoleWriter.clear_screen()
    ConsoleWriter.welcome_message()
    start_application(ConsoleReader, ConsoleWriter)
  end

  def start_application(display_reader, display_writer) do
    %{:team_type => :fixed, :options => 4}
    |> request_members([], display_reader, display_writer)
  end

  def request_members(team_type, teams, display_reader, display_writer) do
    display_reader
    |> Members.next_instruction
    |> process_members(teams, team_type, display_reader, display_writer)
  end

  defp process_members(:quit, _, _, _, display_writer), do: display_writer.goodbye_message()

  defp process_members(new_members, teams, team_type, display_reader, display_writer) do
    ConsoleWriter.clear_screen()
    members = Members.combine_members(teams, new_members)
    new_teams = Team.allocate_members(team_type, members)
    display_writer.display_teams(new_teams)
    request_members(team_type, new_teams, display_reader, display_writer)
  end
end
