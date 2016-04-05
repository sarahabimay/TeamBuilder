defmodule MembersTest do
  use ExUnit.Case
  doctest TeamBuilder
  alias TeamBuilder.Members

  defmodule FakeDisplay do
    def next_command(), do: "Sarah"
  end

  test "'empty' new member not added to existing members" do
    new_member = ""
    members = ["April", "May"]
    expected = ["April", "May"]
    assert Members.add_to_members(members, new_member) == expected
  end

  test "new member added to existing members" do
    new_member = "Sarah"
    members = ["April", "May"]
    expected = ["April", "May", "Sarah"]
    assert Members.add_to_members(members, new_member) == expected
  end

  test "add new member to existing members" do
    new_member = ["Sarah"]
    teams = [
      %{:team => 1, :names => ["April"]},
      %{:team => 2, :names => ["May"]},
      %{:team => 3, :names => []},
      %{:team => 4, :names => []}
    ]
    expected = ["April", "May", "Sarah"]
    assert Members.combine_members(teams, new_member) == expected
  end
end
