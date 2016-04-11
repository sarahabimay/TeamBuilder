defmodule TeamBuilderAppTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias TeamBuilder.Console
  alias TeamBuilder.TeamBuilderApp

  setup do
    {:ok,
     seed_state: :rand.export_seed_s(:rand.seed(:exsplus)),
   }
  end

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

  test "typing q, closes the application", context do
    assert TeamBuilderApp.prompt_for_command([], FakeDisplay, context[:seed_state]) == "GoodBye"
  end

  test "empty string value is not added to members", context do
    expected_result =  "Thank you for using TeamBuilder.\n"
    result = capture_io([input: "\nq\n", capture_prompt: false], fn() ->
      IO.write TeamBuilderApp.prompt_for_command([], Console, context[:seed_state])
    end)
    assert String.contains?(result, expected_result)
  end

  test "fixed number of teams chosen as the team type", context do
    [a1, a2] = TestHelper.generate_members(2)
    team_type = "1 --4"
    input = "#{a1}\n#{a2}\nb\n#{team_type}\nq\n"
    [first, second] = Enum.take_random([a1, a2], 4)
    expected_result = "[ Team 1 ]\n" <>
                      "[1] #{first}\n\n" <>
                      "[ Team 2 ]\n" <>
                      "[1] #{second}"
    result = capture_io([input: input, capture_prompt: false], fn() ->
      IO.write TeamBuilderApp.prompt_for_command([], Console, context[:seed_state])
    end)
    assert String.contains?(result, expected_result)
  end

  test "max size teams chosen as the team type", context do
    [a1, a2, a3] = TestHelper.generate_members(3)
    max_size_team_type = "2 --4"
    input = "#{a1}\n#{a2}\n#{a3}\nb\n#{max_size_team_type}\nq\n"
    [first, second, third] = Enum.take_random([a1, a2, a3], 3)
    expected_result = "[1] #{first}\n" <>
                      "[2] #{second}\n" <>
                      "[3] #{third}"
    result = capture_io([input: input, capture_prompt: false], fn() ->
      IO.write TeamBuilderApp.prompt_for_command([], Console, context[:seed_state])
    end)
    assert String.contains?(result, expected_result)
  end
end
