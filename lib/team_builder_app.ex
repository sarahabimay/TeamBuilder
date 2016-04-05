defmodule TeamBuilder.TeamBuilderApp do
  alias TeamBuilder.Members
  alias TeamBuilder.Teams
  alias TeamBuilder.TeamTypeOptions
  alias TeamBuilder.Commands

  def start_application(members, display_reader, display_writer, seed_state) do
    display_writer.clear_screen()
    display_writer.welcome_message()
    prompt_for_command(members, display_reader, display_writer, seed_state)
  end

  def prompt_for_command(members, display_reader, display_writer, seed_state) do
    display_reader
    |> next_command
    |> process_command(members, display_reader, display_writer, seed_state)
  end

  defp process_command(:quit, _, _, display_writer, _), do: display_writer.goodbye_message()

  defp process_command(:build_teams, members, display_reader, display_writer, seed_state) do
    display_writer.clear_screen()
    {teams, next_seed_state} = build_teams(members, display_reader, seed_state)
    display_writer.display_teams(teams)
    prompt_for_command(members, display_reader, display_writer, next_seed_state)
  end

  defp process_command({:add_member, new_member}, members, display_reader, display_writer, seed_state) do
    display_writer.clear_screen()
    all_members = Members.add_to_members(members, new_member)
    display_writer.display_members(all_members)
    prompt_for_command(all_members, display_reader, display_writer, seed_state)
  end

  defp build_teams(members, display_reader, seed_state) do
    get_team_type(display_reader)
    |> Teams.allocate_members(members, seed_state)
  end

  defp get_team_type(display_reader) do
    display_reader.team_type_options()
    |> TeamTypeOptions.get_team_type
  end

  defp next_command(display_reader) do
    display_reader.next_command
    |> Commands.command_type
  end
end
