defmodule TeamBuilder.TeamTypeOptions do
  alias TeamBuilder.Messages
  alias TeamBuilder.Allocators.FixedTeam
  alias TeamBuilder.Allocators.MaxSizeTeam

  @team_types [
    %{
      :menu_option => 1,
      :team_type => :fixed,
      :team_type_allocator => FixedTeam,
      :description => Messages.fixed_teams_option(),
      :type_options => :max_number_of_teams
    },
    %{
      :menu_option => 2,
      :team_type => :max_size,
      :team_type_allocator => MaxSizeTeam,
      :description => Messages.max_size_teams_option(),
      :type_options => :max_team_size
    }
  ]

  def options, do: @team_types

  def valid_options?(choice) do
    choice
    |> choices_as_integers
    |> valid_choices?
  end

  def get_team_type(team_type_choice) do
    team_type_choice
    |> choices_as_integers
    |> format_team_type_details
  end

  defp format_team_type_details([menu_option, type_option]) do
    menu_option
    |> find_team_type
    |> team_type_details(type_option)
  end

  defp find_team_type(menu_option) do
    @team_types
    |> Enum.filter(fn(type) -> type[:menu_option] == menu_option end)
  end

  defp team_type_details([], _), do: %{:team_type => nil}
  defp team_type_details([chosen_option], type_option) do
    %{
      :team_type => chosen_option[:team_type],
      :team_allocator => chosen_option[:team_type_allocator],
      :options => type_option
    }
  end

  defp valid_choices?([_]), do: false
  defp valid_choices?([mo, to]) when mo == :error or to == :error, do: false
  defp valid_choices?([menu_option, type_option]) do
    valid?(menu_option, validate_menu_option) && valid?(type_option, validate_type_option)
  end

  defp valid?(value_to_validate, action), do: action.(value_to_validate)

  defp validate_menu_option do
    fn(menu_option) ->
      @team_types
      |> Enum.any?(fn(option) -> option[:menu_option] == menu_option end)
    end
  end

  defp validate_type_option, do: fn(type_option) -> type_option > 0 end

  defp choices_as_integers(choices) do
    choices
    |> parse_choice
    |> convert_to_integer
  end

  defp parse_choice(choices) do
    choices
    |> extract_selection
    |> remove_whitespace
  end

  defp extract_selection(choices), do: String.split(choices, "--")

  defp remove_whitespace(selections) do
    selections
    |> Enum.map(fn(detail) -> String.strip(detail) end)
  end

  defp convert_to_integer(options) do
    options
    |> Enum.map(fn(option) -> option_to_integer(option) end)
  end

  defp option_to_integer(option) do
    option
    |> Integer.parse
    |> extract_integer
  end

  defp extract_integer({int, _}), do: int

  defp extract_integer(:error), do: :error
end
