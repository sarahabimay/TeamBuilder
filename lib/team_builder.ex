defmodule TeamBuilder do
  alias TeamBuilder.Console
  alias TeamBuilder.TeamBuilderApp

  def main(_) do
    seed_state = :rand.export_seed_s(:rand.seed(:exsplus))
    TeamBuilderApp.start_application([], Console, seed_state)
  end
end
