defmodule TeamBuilderAppTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias TeamBuilder.Console
  alias TeamBuilder.TeamBuilderApp
  doctest TeamBuilder

  defmodule FakeDisplay do
    def next_command() do
      "q"
    end

    def team_type_options() do
      4
    end

    def display_teams(teams) do
      teams
    end

    def goodbye_message() do
      "GoodBye"
    end
  end

  test "typing q, closes the application" do
    seed_state = :rand.export_seed_s(:rand.seed(:exsplus))
    assert TeamBuilderApp.prompt_for_command([], FakeDisplay, seed_state) == "GoodBye"
  end

  test "empty string value is not added to members" do
    empty_line = ""
    quit = "q"
    seed_state = :rand.export_seed_s(:rand.seed(:exsplus))
    expected_result =  "[ Members Added ]\n\n" <>
                        "Thank you for using TeamBuilder.\n"
    result = capture_io([input: "#{empty_line}\n#{quit}\n", capture_prompt: false], fn() ->
      IO.write TeamBuilderApp.prompt_for_command([], Console, seed_state)
    end)
    assert String.contains?(result, expected_result)
  end

  test "fixed teams: typing b, builds the 4 empty teams" do
    build = "b"
    team_type = "1 - 4"
    quit = "q"
    seed_state = :rand.export_seed_s(:rand.seed(:exsplus))
    expected_result = "Thank you for using TeamBuilder.\n"
    result = capture_io([input: "#{build}\n#{team_type}\n#{quit}\n", capture_prompt: false], fn() ->
      IO.write TeamBuilderApp.prompt_for_command([], Console, seed_state)
    end)
    assert String.contains?(result, expected_result)
  end

  test "fixed number of teams chosen as the team type" do
    [a1, a2] = TestHelper.generate_members(2)
    build_command = "b"
    team_type = "1 - 4"
    input = "#{a1}\n#{a2}\n#{build_command}\n#{team_type}\nq\n"
    seed_state = :rand.export_seed_s(:rand.seed(:exsplus))
    [first, second] = Enum.take_random([a1, a2], 4)
    expected_result = "[ Team 1 ]\n" <>
                      "[1] #{first}\n\n" <>
                      "[ Team 2 ]\n" <>
                      "[1] #{second}\n\n" <>
                      "Thank you for using TeamBuilder.\n"
    result = capture_io([input: input, capture_prompt: false], fn() ->
      IO.write TeamBuilderApp.prompt_for_command([], Console, seed_state)
    end)
    assert String.contains?(result, expected_result)
  end

  test "max size teams chosen as the team type" do
    max_size = 3
    members = TestHelper.generate_members(3)
    [a1, a2, a3] = members
    build_command = "b"
    max_size_team_type = "2 - #{max_size}"
    input = "#{a1}\n#{a2}\n#{a3}\n#{build_command}\n#{max_size_team_type}\nq\n"
    seed_state = :rand.export_seed_s(:rand.seed(:exsplus))
    [first, second, third] = Enum.take_random(members, max_size)
    expected_result = "[ Team 1 ]\n" <>
                      "[1] #{first}\n" <>
                      "[2] #{second}\n" <>
                      "[3] #{third}\n\n" <>
                      "Thank you for using TeamBuilder.\n"
    result = capture_io([input: input, capture_prompt: false], fn() ->
      IO.write TeamBuilderApp.prompt_for_command([], Console, seed_state)
    end)
    assert String.contains?(result, expected_result)
  end
end
