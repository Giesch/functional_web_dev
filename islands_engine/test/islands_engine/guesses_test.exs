defmodule IslandsEngineTest.GuessesTest do
  use ExUnit.Case
  alias IslandsEngine.{Coordinate, Guesses}

  test "it adds hits to hits" do
    guesses = Guesses.new()
    {:ok, coordinate1} = Coordinate.new(8, 3)
    guesses = Guesses.add(guesses, :hit, coordinate1)
    {:ok, coordinate2} = Coordinate.new(9, 7)
    guesses = Guesses.add(guesses, :hit, coordinate2)
    assert MapSet.member?(guesses.hits, coordinate1)
    assert MapSet.member?(guesses.hits, coordinate2)
  end

  test "it adds misses to misses" do
    guesses = Guesses.new()
    {:ok, coordinate1} = Coordinate.new(8, 3)
    guesses = Guesses.add(guesses, :miss, coordinate1)
    assert MapSet.member?(guesses.misses, coordinate1)
  end
end
