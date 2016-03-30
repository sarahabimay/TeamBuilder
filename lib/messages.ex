defmodule TeamBuilder.Messages do
  def welcome(), do: "Welcome to TeamBuilder. Please add your first invitee."

  def add_members(), do: "Add Team Members"

  def quit(), do: "[q] Quit"

  def build_teams(), do: "[b] Build Teams"

  def members_header(), do: "[ Members Added ]"

  def team_table_header(team_number), do: "[ Team #{team_number} ]"

  def goodbye(), do: "Thank you for using TeamBuilder."
end
