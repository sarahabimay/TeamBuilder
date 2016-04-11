defmodule TeamBuilder.TeamBuilderApp do
  alias TeamBuilder.Members
  alias TeamBuilder.TeamTypeOptions
  alias TeamBuilder.Commands

  def start_application(members, display, seed_state) do
    display.welcome_message
    prompt_for_command(members, display, seed_state)
  end

  def prompt_for_command(members, display, seed_state) do
    display
    |> next_command
    |> process_command(members, display, seed_state)
  end

  defp process_command(:quit, _, display, _), do: display.goodbye_message

  defp process_command(:build_teams, members, display, seed_state) do
    display.clear_screen
    {teams, next_seed_state} = build_teams(members, display, seed_state)
    display.display_teams(teams)
    prompt_for_command(members, display, next_seed_state)
  end

  defp process_command({:add_member, new_member}, members, display, seed_state) do
    display.clear_screen
    all_members = Members.add_to_members(members, new_member)
    display.display_members(all_members)
    prompt_for_command(all_members, display, seed_state)
  end

  defp build_teams(members, display, seed_state) do
    get_team_type(display)
    |> Members.allocate_teams(members, seed_state)
  end

  defp get_team_type(display) do
    display.team_type_options
    |> TeamTypeOptions.get_team_type
  end

  defp next_command(display) do
    display.next_command
    |> Commands.command_type
  end
end
