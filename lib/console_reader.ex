defmodule TeamBuilder.ConsoleReader do
  alias TeamBuilder.Messages

  def add_members() do
    Messages.add_members()
    |> append_space
    |> IO.gets
  end

  defp append_space(message), do: message <> " "
end