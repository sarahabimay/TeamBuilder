defmodule TeamBuilder do
  alias TeamBuilder.Console
  alias TeamBuilder.Members
  alias TeamBuilder.TeamBuilderApp

  def main(_) do
    seed_state = :rand.export_seed_s(:rand.seed(:exsplus))
    TeamBuilderApp.start_application(Members.members(), Console, seed_state)
  end
end
