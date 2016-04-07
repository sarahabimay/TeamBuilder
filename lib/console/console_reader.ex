defmodule TeamBuilder.ConsoleReader do
  alias TeamBuilder.ConsoleWriter
  alias TeamBuilder.Messages
  alias TeamBuilder.TeamTypeOptions

  def next_command() do
    next_command_message()
    |> IO.gets
    |> String.strip
  end

  def team_type_options() do
    team_options_message()
    |> IO.gets
    |> String.strip
    |> valid_choice
  end

  defp next_command_message() do
    Messages.add_members()
    |> append_commands
  end

  defp append_commands(message) do
    message
    |> append_char(" (")
    |> append_char(Messages.quit())
    |> append_char(" - ")
    |> append_char(Messages.build_teams())
    |> append_char("): ")
  end

  defp team_options_message() do
    team_type_options_header() <>
    team_type_options_descriptions() <>
    "> "
  end

  defp team_type_options_header() do
    Messages.team_type_options()
    |> append_new_line
  end

  defp team_type_options_descriptions() do
    TeamTypeOptions.options()
    |> Enum.with_index
    |> Enum.reduce("", fn({type, index}, acc) -> acc <> numbered_list_item(type, index) end)
  end

  defp valid_choice(choice) do
    if TeamTypeOptions.valid_option?(choice) do
      choice
    else
      team_type_options()
    end
  end

  defp numbered_list_item(team_type_option, index) do
    "[#{one_indexed(index)}] #{team_type_option[:description]} #{user_instructions(team_type_option, index)}\n"
  end

  defp user_instructions(team_type_option, index) do
    "[enter: #{one_indexed(index)} - #{team_type_option[:type_options]}]"
  end

  defp append_char(message, chars), do: message <> chars

  defp append_new_line(message), do: message <> "\n"

  defp one_indexed(number), do: number + 1
end
