defmodule ConsoleReaderTest do
  use ExUnit.Case
  doctest TeamBuilder
  import ExUnit.CaptureIO
  alias TeamBuilder.ConsoleReader

  test "prompt for team member" do
    member = "Sarah"
    result = capture_io([input: member], fn ->
      IO.write ConsoleReader.add_members()
    end)
    assert result == "Add Team Members: Sarah"
  end
end