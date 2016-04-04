defmodule TeamTypeOptionsTest do
  use ExUnit.Case
  doctest TeamBuilder
  alias TeamBuilder.TeamTypeOptions

  test "two options for types of team allocation" do
    expected = [
      %{ :menu_option => 1, :team_type => :fixed, :description =>  "Fixed Number Of Teams", :type_options => :max_number_of_teams },
    ]
    assert TeamTypeOptions.options() == expected
  end

  test "lookup valid choice" do
    valid_choice = "1 - 4"
    assert TeamTypeOptions.valid_option?(valid_choice)
  end

  test "invalid if hyphen but missing invalid choice" do
    invalid_choice = "1 -"
    assert not TeamTypeOptions.valid_option?(invalid_choice)
  end

  test "invalid if missing type_option choice" do
    invalid_choice = "1"
    assert not TeamTypeOptions.valid_option?(invalid_choice)
  end

  test "invalid menu_option choice" do
    invalid_choice = "5 - 4"
    assert not TeamTypeOptions.valid_option?(invalid_choice)
  end

  test "invalid because missing menu_option choice" do
    invalid_choice = "- 4"
    assert not TeamTypeOptions.valid_option?(invalid_choice)
  end

  test "invalid type_option choice" do
    invalid_choice = "1 - a"
    assert not TeamTypeOptions.valid_option?(invalid_choice)
  end

  test "choose option 1 with value 4" do
    choice = "1 - 4"
    expected_type = %{:team_type => :fixed, :options => 4}
    assert TeamTypeOptions.get_team_type(choice) == expected_type
  end

  test "invalid option returns nil" do
    choice = "4 - 8"
    expected_type = %{:team_type => nil}
    assert TeamTypeOptions.get_team_type(choice) == expected_type
  end
end
