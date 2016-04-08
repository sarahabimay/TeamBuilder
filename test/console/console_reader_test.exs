defmodule ConsoleReaderTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias TeamBuilder.ConsoleReader

  test "prompt for team member" do
    result = capture_io([input: "Sarah"], fn ->
      IO.write ConsoleReader.next_command()
    end)
    assert result == "Add Team Member ([q] Quit - [b] Build Teams): Sarah"
  end

  test "valid team type choice" do
    choice = "1 - 4"
    expected =
               "[1] Fixed Number Of Teams [enter: 1 - max_number_of_teams]\n" <>
               "[2] Max Team Size [enter: 2 - max_team_size]\n" <>
               "> #{choice}"
    result = capture_io([input: "#{choice}"], fn -> IO.write ConsoleReader.team_type_options() end)
    assert String.contains?(result, expected)
  end

  test "invalid team type choice prompt for another choice" do
    invalid_choice = "one"
    valid_choice = "1 - 4"
    expected =
               "[1] Fixed Number Of Teams [enter: 1 - max_number_of_teams]\n" <>
               "[2] Max Team Size [enter: 2 - max_team_size]\n" <>
               "> #{valid_choice}"
    result = capture_io([input: "#{invalid_choice}\n#{valid_choice}\n"], fn -> IO.write ConsoleReader.team_type_options() end)
    assert String.contains?(result, expected)
  end
end
