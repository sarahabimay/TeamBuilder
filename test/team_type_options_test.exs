defmodule TeamTypeOptionsTest do
  use ExUnit.Case
  alias TeamBuilder.TeamTypeOptions
  alias TeamBuilder.Allocators.FixedTeam
  alias TeamBuilder.Allocators.MaxSizeTeam

  test "options for types of team allocation" do
    expected = [
      %{
        :menu_option => 1,
        :team_type_allocator => FixedTeam,
        :team_type => :fixed,
        :description =>  "Fixed Number Of Teams",
        :type_options => :max_number_of_teams
      },
      %{
        :menu_option => 2,
        :team_type => :max_size,
        :team_type_allocator => MaxSizeTeam,
        :description => "Max Team Size",
        :type_options => :max_team_size
      }
    ]
    assert TeamTypeOptions.options == expected
  end

  test "lookup valid choice" do
    valid_choice = "1 --4"
    assert TeamTypeOptions.valid_options?(valid_choice)
  end

  test "invalid menu_option choice" do
    invalid_choice = "5 -- 4"
    assert not TeamTypeOptions.valid_options?(invalid_choice)
  end

  test "invalid if menu option is zero" do
    invalid_choice = "0 -- -2"
    assert not TeamTypeOptions.valid_options?(invalid_choice)
  end

  test "invalid if negative type" do
    invalid_choice = "-1 -- 2"
    assert not TeamTypeOptions.valid_options?(invalid_choice)
  end

  test "invalid type_option choice is not a number" do
    invalid_choice = "1 -- a"
    assert not TeamTypeOptions.valid_options?(invalid_choice)
  end

  test "invalid if type option is zero" do
    invalid_choice = "1 -- 0"
    assert not TeamTypeOptions.valid_options?(invalid_choice)
  end

  test "invalid if negative type option" do
    invalid_choice = "1 -- -2"
    assert not TeamTypeOptions.valid_options?(invalid_choice)
  end

  test "invalid if a single hyphen" do
    invalid_choice = "1 - 2"
    assert not TeamTypeOptions.valid_options?(invalid_choice)
  end

  test "invalid if hyphen but missing invalid choice" do
    invalid_choice = "1 --"
    assert not TeamTypeOptions.valid_options?(invalid_choice)
  end

  test "invalid if missing type_option choice" do
    invalid_choice = "1"
    assert not TeamTypeOptions.valid_options?(invalid_choice)
  end

  test "invalid because missing menu_option choice" do
    invalid_choice = "-- 4"
    assert not TeamTypeOptions.valid_options?(invalid_choice)
  end

  test "choose fixed team type option" do
    choice = "1 -- 4"
    expected_type = %{
      :team_type => :fixed,
      :team_allocator => FixedTeam,
      :options => 4
    }
    assert TeamTypeOptions.get_team_type(choice) == expected_type
  end

  test "choose max team size option" do
    choice = "2 -- 8"
    expected_type = %{
      :team_type => :max_size,
      :team_allocator => MaxSizeTeam,
      :options => 8
    }
    assert TeamTypeOptions.get_team_type(choice) == expected_type
    assert TeamTypeOptions.get_team_type(choice) == expected_type
  end

  test "invalid option returns nil" do
    choice = "4 -- 8"
    expected_type = %{:team_type => nil}
    assert TeamTypeOptions.get_team_type(choice) == expected_type
  end
end
