defmodule CommandsTest do
  use ExUnit.Case
  doctest TeamBuilder
  alias TeamBuilder.Commands

  test "'q' value is interpreted as 'quit'" do
    assert Commands.translate_command("q") == :quit
  end

  test "'b' value is interpreted as 'build teams'" do
    assert Commands.translate_command("b") == :build_teams
  end

  test "any other value is interpreted as a new member command" do
    assert Commands.translate_command("Bob") == "Bob"
  end
end
