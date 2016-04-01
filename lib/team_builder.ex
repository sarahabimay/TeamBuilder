defmodule TeamBuilder do
  alias TeamBuilder.ConsoleWriter
  alias TeamBuilder.ConsoleReader
  alias TeamBuilder.TeamBuilderApp

  def main(_) do
    seed_state = :rand.export_seed_s(:rand.seed(:exsplus))
    TeamBuilderApp.start_application([], ConsoleReader, ConsoleWriter, seed_state)
  end
end
