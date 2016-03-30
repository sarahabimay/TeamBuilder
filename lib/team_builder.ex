defmodule TeamBuilder do
  alias TeamBuilder.ConsoleWriter
  alias TeamBuilder.ConsoleReader
  alias TeamBuilder.TeamBuilderApp

  def main(_) do
    TeamBuilderApp.start_application([], ConsoleReader, ConsoleWriter)
  end
end
