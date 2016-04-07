defmodule ConsoleTest do
  use ExUnit.Case
  doctest TeamBuilder
  import ExUnit.CaptureIO
  alias TeamBuilder.Console

  test "prompt for team member" do
    member = "Sarah"
    result = capture_io([input: member], fn ->
      IO.write Console.next_command()
    end)
    assert result == "Add Team Member ([q] Quit - [b] Build Teams): Sarah"
  end

  test "prompt for team type choice" do
    choice = "1 - 4"
    expected = "[ Team Type Options ]\n" <>
               "[1] Fixed Number Of Teams [enter: 1 - max_number_of_teams]\n" <>
               "[2] Max Team Size [enter: 2 - max_team_size]\n" <>
               "> #{choice}"
    result = capture_io([input: choice], fn -> IO.write Console.team_type_options() end)
    assert String.contains?(result, expected)
  end

  test "welcome message displayed" do
    result = capture_io(fn -> Console.welcome_message() end)
    assert result == "Welcome to TeamBuilder. Please add your first invitee.\n"
  end

  test "goodbye message displayed" do
    result = capture_io(fn -> Console.goodbye_message() end)
    assert result == "Thank you for using TeamBuilder.\n"
  end

  test "team tables displayed" do
    teams = [
              %{ :team => 1, :names => ["Sarah", "Mael", "Jarkyn"] },
            ]
    expected = "[ Team 1 ]\n" <>
               "[1] Sarah\n" <>
               "[2] Mael\n" <>
               "[3] Jarkyn\n\n"

    result = capture_io(fn -> Console.display_teams(teams) end)
    assert result == expected
  end

  test "members all displayed" do
    all_members = ["Sarah", "Abigail", "May"]
    expected = "[ Members Added ]\n" <>
               "[1] Sarah\n" <>
               "[2] Abigail\n" <>
               "[3] May\n\n"
    result = capture_io(fn -> Console.display_members(all_members) end)
    assert result == expected
  end
end
