defmodule TeamGeneratorTest do
  use ExUnit.Case
  doctest TeamBuilder
  alias TeamBuilder.TeamGenerator

  test "two members generates two Teams" do
    [a1, a2] = generate_members(2)
    expected_result = [
              %{:team => 1, :names => [a1]},
              %{:team => 2, :names => [a2]},
              %{:team => 3, :names => []},
              %{:team => 4, :names => []}]
    assert TeamGenerator.allocate_teams(get_teams(4), [a1, a2]) == expected_result
  end

  test "eight members generates 4 Teams with 2 members each" do
    [a1, a2, a3, a4, a5, a6, a7, a8] = generate_members(8)
    expected_result = [
              %{:team => 1, :names => [a1, a5] },
              %{:team => 2, :names => [a2, a6] },
              %{:team => 3, :names => [a3, a7] },
              %{:team => 4, :names => [a4, a8] }]
    all_members = [a1, a2, a3, a4, a5, a6, a7, a8]
    assert TeamGenerator.allocate_teams(get_teams(4), all_members) == expected_result
  end

  def generate_members(number) do
    Enum.map(1..number, fn(num) -> "name#{num}" end)
  end

  def get_teams(number) when number == 4 do
    [
      %{:team => 1, :names => []},
      %{:team => 2, :names => []},
      %{:team => 3, :names => []},
      %{:team => 4, :names => []},
    ]
  end
end
