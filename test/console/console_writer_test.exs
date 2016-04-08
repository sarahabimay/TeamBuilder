defmodule ConsoleWriterTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias TeamBuilder.ConsoleWriter

  test "welcome message displayed" do
    result = capture_io(fn -> ConsoleWriter.welcome_message() end)
    assert result == "Welcome to TeamBuilder. Please add your first invitee.\n"
  end

  test "goodbye message displayed" do
    result = capture_io(fn -> ConsoleWriter.goodbye_message() end)
    assert result == "Thank you for using TeamBuilder.\n"
  end

  test "empty team tables displayed" do
    teams = [
      %{ :team => 1, :names => [] },
      %{ :team => 2, :names => [] }
    ]

    result = capture_io(fn -> ConsoleWriter.display_teams(teams) end)
    assert result == "[ Team 1 ]\n\n" <>
    "[ Team 2 ]\n\n"
  end

  test "team tables displayed" do
    teams = [
      %{ :team => 1, :names => ["Sarah", "Mael", "Jarkyn"] },
      %{ :team => 2, :names => ["Georgina", "Priya", "Rabea"] }
    ]
    expected =
    "[1] Sarah\n" <>
    "[2] Mael\n" <>
    "[3] Jarkyn\n\n" <>

    "[ Team 2 ]\n" <>
    "[1] Georgina\n" <>
    "[2] Priya\n" <>
    "[3] Rabea"

    result = capture_io(fn -> ConsoleWriter.display_teams(teams) end)
    assert String.contains?(result, expected)
  end

  test "members all displayed" do
    [a1, a2, a3] = TestHelper.generate_members(3)
    expected =
    "[1] #{a1}\n" <>
    "[2] #{a2}\n" <>
    "[3] #{a3}"
    result = capture_io(fn -> ConsoleWriter.display_members([a1, a2, a3]) end)
    assert String.contains?(result, expected)
  end
end
