ExUnit.start()

defmodule TestHelper do
  def generate_members(number) do
    Enum.map(1..number, fn(num) -> "name#{num}" end)
  end

  def remaining_members(selected_members, all_members) do
    all_members -- selected_members
  end
end
