defmodule TeamBuilder.Console do
  alias TeamBuilder.Messages
  alias TeamBuilder.TeamTypeOptions

  def next_command do
    next_command_message
    |> IO.gets
    |> String.strip
  end

  def team_type_options do
    clear_screen
    _team_type_options
  end

  def welcome_message do
    clear_screen
    IO.puts(Messages.welcome)
  end

  def goodbye_message, do: IO.puts(Messages.goodbye)

  def display_members(members), do: IO.write(members_header <> team_members(members))

  def display_teams(teams) do
    teams
    |> Enum.map(fn(team) -> team_name(team) <> team_members(team[:names]) end)
    |> Enum.join("")
    |> IO.write
  end

  def clear_screen do
    IO.ANSI.clear |> IO.write
    IO.ANSI.home |> IO.write
  end

  defp members_header do
    Messages.members_header
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

  def _team_type_options do
    team_options_message
    |> IO.gets
    |> String.strip
    |> valid_choice
  end

  defp valid_choice(choice) do
    if TeamTypeOptions.valid_options?(choice), do: choice, else: team_type_options
  end

  defp next_command_message do
    Messages.add_members
    |> append_commands
  end

  defp append_commands(message) do
    message
    |> append_char(" (")
    |> append_char(Messages.quit)
    |> append_char(" - ")
    |> append_char(Messages.build_teams)
    |> append_char("): ")
  end

  defp team_options_message do
    team_type_options_header <>
    team_type_options_descriptions <>
    "> "
  end

  defp team_type_options_header do
    Messages.team_type_options
    |> append_new_line
  end

  defp team_type_options_descriptions do
    TeamTypeOptions.options
    |> Enum.with_index
    |> Enum.map(fn({type, index}) -> team_type_description(type, index) end)
    |> Enum.join("\n")
    |> append_new_line
  end

  defp team_type_description(team_type_option, index) do
    "#{numbered_list_item(team_type_option, index)}\n" <>
    "#{user_instructions(team_type_option, index)}"
  end

  defp numbered_list_item(team_type_option, index) do
    "[#{one_indexed(index)}] #{team_type_option[:description]}"
  end

  defp user_instructions(team_type_option, index) do
    "usage: #{one_indexed(index)} --<#{team_type_option[:type_options]}>"
  end

  defp append_char(message, chars), do: message <> chars

  defp append_new_line(message), do: message <> "\n"

  defp one_indexed(number), do: number + 1
end
