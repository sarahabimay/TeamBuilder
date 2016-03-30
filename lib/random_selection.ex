defmodule TeamBuilder.RandomSelection do
  def take_random(members, team_count) do
      Enum.take_random(members, team_count)
  end
end
