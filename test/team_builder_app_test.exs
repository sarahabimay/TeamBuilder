defmodule TeamBuilderAppTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias TeamBuilder.ConsoleReader
  alias TeamBuilder.ConsoleWriter
  alias TeamBuilder.TeamBuilderApp
  doctest TeamBuilder

  @team_type %{:team_type => :fixed, :options => 4}

  defmodule FakeReader do
    def next_command() do
      "q"
    end

    def team_type_options() do
      4
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
    seed_state = :rand.export_seed_s(:rand.seed(:exsplus))
    assert TeamBuilderApp.prompt_for_command([], FakeReader, FakeWriter, seed_state) == "GoodBye"
  end

  test "typing b, builds the 4 empty teams" do
    input = "b\nq\n"
    seed_state = :rand.export_seed_s(:rand.seed(:exsplus))
    expected_result = "[ Team 1 ]\n\n" <>
                      "[ Team 2 ]\n\n" <>
                      "[ Team 3 ]\n\n" <>
                      "[ Team 4 ]\n\n" <>
                      "Thank you for using TeamBuilder.\n"
    result = capture_io([input: input, capture_prompt: false], fn() ->
      IO.write TeamBuilderApp.prompt_for_command([], ConsoleReader, ConsoleWriter, seed_state)
    end)
    assert String.contains?(result, expected_result)
  end

  test "consecutive new members redistributed across teams" do
    [a1, a2] = generate_members(2)
    input = "#{a1}\n#{a2}\nb\nq\n"
    seed_state = :rand.export_seed_s(:rand.seed(:exsplus))
    [first, second] = Enum.take_random([a1, a2], 4)
    expected_result = "[ Team 1 ]\n" <>
                       "[1] #{first}\n\n" <>
                       "[ Team 2 ]\n" <>
                       "[1] #{second}\n\n" <>
                       "[ Team 3 ]\n\n" <>
                       "[ Team 4 ]\n\n" <>
                       "Thank you for using TeamBuilder.\n"
    result = capture_io([input: input, capture_prompt: false], fn() ->
      IO.write TeamBuilderApp.prompt_for_command([], ConsoleReader, ConsoleWriter, seed_state)
    end)
    assert String.contains?(result, expected_result)
  end

  def generate_members(number) do
    Enum.map(1..number, fn(num) -> "name#{num}" end)
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
