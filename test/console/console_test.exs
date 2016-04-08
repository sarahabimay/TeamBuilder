defmodule ConsoleTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias TeamBuilder.Console

  test "prompt for team member" do
    result = capture_io([input: "Sarah"], fn -> IO.write Console.next_command() end)
    assert result == "Add Team Member ([q] Quit - [b] Build Teams): Sarah"
  end

  test "prompt for team type choice" do
    choice = "1 - 4"
    expected =
    "[1] Fixed Number Of Teams [enter: 1 - max_number_of_teams]\n" <>
    "[2] Max Team Size [enter: 2 - max_team_size]\n" <>
    "> #{choice}"
    result = capture_io([input: choice], fn -> IO.write Console.team_type_options() end)
    assert String.contains?(result, expected)
  end

  test "welcome message displayed" do
    result = capture_io(fn -> Console.welcome_message() end)
    assert String.contains?(result, "Welcome to TeamBuilder.")
  end

  test "goodbye message displayed" do
    result = capture_io(fn -> Console.goodbye_message() end)
    assert String.contains?(result, "Thank you for using TeamBuilder.")
  end

  test "team tables displayed" do
    teams = [
      %{ :team => 1, :names => ["Sarah", "Mael", "Jarkyn"] },
    ]
    expected =
    "[1] Sarah\n" <>
    "[2] Mael\n" <>
    "[3] Jarkyn"

    result = capture_io(fn -> Console.display_teams(teams) end)
    assert String.contains?(result, expected)
  end

  test "members all displayed" do
    expected =
    "[1] Sarah\n" <>
    "[2] Abigail\n" <>
    "[3] May"
    result = capture_io(fn -> Console.display_members(["Sarah", "Abigail", "May"]) end)
    assert String.contains?(result, expected)
  end
end
