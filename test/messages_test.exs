defmodule MessagesTest do
  use ExUnit.Case
  doctest TeamBuilder
  alias TeamBuilder.Messages

  test "welcome message" do
    assert Messages.welcome() == "Welcome to TeamBuilder. " <>
                                 "Please add your first invitee."
  end

  test "add team member message" do
    assert Messages.add_members() == "Add Team Members"
  end

  test "quit message" do
    assert Messages.quit() == "[q] Quit"
  end

  test "build message" do
    assert Messages.build_teams() == "[b] Build Teams"
  end

  test "members added header message" do
    assert Messages.members_header() == "[ Members Added ]"
  end

  test "team table header message" do
    assert Messages.team_table_header(1) == "[ Team 1 ]"
  end

  test "goodbye message" do
    assert Messages.goodbye() == "Thank you for using TeamBuilder."
  end
end

