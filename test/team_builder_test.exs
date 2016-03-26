defmodule TeamBuilderTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias TeamBuilder.ConsoleReader
  alias TeamBuilder.ConsoleWriter
  doctest TeamBuilder


  @team_type %{:team_type => :fixed, :options => 4}

  defmodule FakeReader do
   def add_members() do
     "q"
   end
  end

  defmodule FakeWriter do
    def display_teams(teams) do
      teams
    end

    def goodbye_message() do
      "GoodBye"
    end
  end

  test "typing q, closes the application" do
    assert TeamBuilder.request_members(@team_type, [], FakeReader, FakeWriter) == "GoodBye"
  end

  test "consecutive new members redistributed across teams" do
    expected_result = "[ Team 1 ]\n" <>
                       "[1] Sarah\n\n" <>
                       "[ Team 2 ]\n" <>
                       "[1] James\n\n" <>
                       "[ Team 3 ]\n\n" <>
                       "[ Team 4 ]\n\n" <>
                       "Thank you for using TeamBuilder.\n"
    input = "Sarah\nJames\nq\n"
    result = capture_io([input: input, capture_prompt: false], fn() ->
      IO.write TeamBuilder.request_members(@team_type, [], ConsoleReader, ConsoleWriter)
    end)
    assert String.contains?(result, expected_result)
  end
end
