defmodule TeamBuilder.ConsoleReader do
  alias TeamBuilder.Messages

  def next_command() do
    next_command_message()
    |> IO.gets
    |> String.strip
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

  defp append_char(message, chars), do: message <> chars
end
