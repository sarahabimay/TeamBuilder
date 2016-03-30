defmodule TeamBuilderTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias TeamBuilder.ConsoleReader
  alias TeamBuilder.ConsoleWriter
  doctest TeamBuilder

  @team_type %{:team_type => :fixed, :options => 4}

  defmodule FakeReader do
   def next_command() do
     :quit
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
    assert TeamBuilder.prompt_for_command([], FakeReader, FakeWriter) == "GoodBye"
  end

  test "typing b, builds the 4 empty teams" do
    input = "b\nq\n"
    expected_result = "[ Team 1 ]\n\n" <>
                      "[ Team 2 ]\n\n" <>
                      "[ Team 3 ]\n\n" <>
                      "[ Team 4 ]\n\n" <>
                      "Thank you for using TeamBuilder.\n"
    result = capture_io([input: input, capture_prompt: false], fn() ->
      IO.write TeamBuilder.prompt_for_command([], ConsoleReader, ConsoleWriter)
    end)
    assert String.contains?(result, expected_result)
  end

  test "consecutive new members redistributed across teams" do
    input = "Sarah\nJames\nb\nq\n"
    expected_result = "[ Team 1 ]\n" <>
                       "[1] Sarah\n\n" <>
                       "[ Team 2 ]\n" <>
                       "[1] James\n\n" <>
                       "[ Team 3 ]\n\n" <>
                       "[ Team 4 ]\n\n" <>
                       "Thank you for using TeamBuilder.\n"
    result = capture_io([input: input, capture_prompt: false], fn() ->
      IO.write TeamBuilder.prompt_for_command([], ConsoleReader, ConsoleWriter)
    end)
    assert String.contains?(result, expected_result)
  end

  def get_teams(4) do
    [
      %{:team => 1, :names => []},
      %{:team => 2, :names => []},
      %{:team => 3, :names => []},
      %{:team => 4, :names => []},
    ]
  end
end
