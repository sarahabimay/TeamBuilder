defmodule CommandsTest do
  use ExUnit.Case
  alias TeamBuilder.Commands

  test "'q' value is interpreted as 'quit'" do
    assert Commands.command_type("q") == :quit
  end

  test "'b' value is interpreted as 'build teams'" do
    assert Commands.command_type("b") == :build_teams
  end

  test "any other value is interpreted as a new member command" do
    assert Commands.command_type("Bob") == {:add_member, "Bob"}
  end
end
