defmodule TeamBuilder.TeamTypeOptions do
  alias TeamBuilder.Messages

  @team_types [
    %{ :menu_option => 1, :team_type => :fixed, :description => Messages.fixed_teams_option(), :type_options => :max_number_of_teams },
  ]

  def options() do
    @team_types
  end

  def valid_option?(choice) do
    choice
    |> parse_choice
    |> integer_choice
    |> valid_choice?
  end

  def get_team_type([menu_option, type_option]) do
    @team_types
    |> Enum.filter(fn(type) -> type[:menu_option] == menu_option end)
    |> create_team_type(type_option)
  end

  def get_team_type(team_type_choice) do
    team_type_choice
    |> parse_choice
    |> integer_choice
    |> get_team_type
  end

  defp parse_choice(choice) do
    choice
    |> String.split("-")
    |> Enum.map(fn(detail) -> String.strip(detail) end)
  end

  defp integer_choice(options) do
    options
    |> Enum.map(fn(option) -> convert_to_integer(option) end)
  end

  defp valid_choice?([_]), do: false

  defp valid_choice?([mo, to]) when mo == :error or to == :error, do: false

  defp valid_choice?([menu_option, type_option]) do
    valid?(menu_option, validate_menu_option) && valid?(type_option, validate_type_option)
  end

  defp valid?(value_to_validate, action) do
    action.(value_to_validate)
  end

  defp validate_menu_option() do
    fn(menu_option) ->
    @team_types
    |> Enum.any?(fn(option) -> option[:menu_option] == menu_option end)
    end
  end

  defp validate_type_option(), do: fn(_) -> true end

  defp convert_to_integer(option) do
    option
    |> Integer.parse
    |> extract_integer
  end

  defp extract_integer({int, _}), do: int

  defp extract_integer(:error), do: :error

  defp create_team_type([], _), do: %{:team_type => nil}

  defp create_team_type([chosen_option], type_option) do
    %{:team_type => chosen_option[:team_type], :options => type_option}
  end
end
