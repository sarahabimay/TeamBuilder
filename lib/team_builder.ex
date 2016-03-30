defmodule TeamBuilder do
  alias TeamBuilder.Members
  alias TeamBuilder.ConsoleWriter
  alias TeamBuilder.ConsoleReader
  alias TeamBuilder.Team

  def main(_) do
    ConsoleWriter.clear_screen()
    ConsoleWriter.welcome_message()
    start_application([], ConsoleReader, ConsoleWriter)
  end

  def start_application(members, display_reader, display_writer) do
    prompt_for_command(members, display_reader, display_writer)
  end

  def prompt_for_command(members, display_reader, display_writer) do
    display_reader
    |> next_command
    |> process_command(members, display_reader, display_writer)
  end

  defp process_command(:quit, _, _, display_writer), do: display_writer.goodbye_message()

  defp process_command(:build_teams, members, display_reader, display_writer) do
    get_team_type()
    |> build_teams(members, display_reader, display_writer)
    prompt_for_command(members, display_reader, display_writer)
  end

  defp process_command(new_member, members, display_reader, display_writer) do
    members
    |> Members.add_to_members(new_member)
    |> prompt_for_command(display_reader, display_writer)
  end

  defp build_teams(team_type, members, _, display_writer) do
    ConsoleWriter.clear_screen()
    team_type
    |> Team.allocate_members(members)
    |> display_writer.display_teams
  end

  defp get_team_type(), do: %{:team_type => :fixed, :options => 4}

  defp next_command(display_reader), do: display_reader.next_command
end
