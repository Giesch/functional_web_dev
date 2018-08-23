defmodule IslandsEngineTest.CoordinateTest do
  use ExUnit.Case, async: true
  alias IslandsEngine.Coordinate

  test "validates coordinates" do
    assert {:error, :invalid_coordinate} == Coordinate.new(1, -1)
    assert {:error, :invalid_coordinate} == Coordinate.new(1, 11)
  end
end
