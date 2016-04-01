defmodule TeamBuilder do
  alias TeamBuilder.ConsoleWriter
  alias TeamBuilder.ConsoleReader
  alias TeamBuilder.RandomTeamAllocator
  alias TeamBuilder.RandomSelection
  alias TeamBuilder.TeamBuilderApp

  def main(_) do
    TeamBuilderApp.start_application([], ConsoleReader, ConsoleWriter, RandomTeamAllocator.team_allocator(RandomSelection))
  end
end
