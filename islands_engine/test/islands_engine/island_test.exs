defmodule IslandsEngineTest.IslandTest do
  use ExUnit.Case, async: true
  alias IslandsEngine.{Coordinate, Island}

  test "happy path" do
    {:ok, coordinate} = Coordinate.new(4, 6)
    assert {:ok, _island} = Island.new(:l_shape, coordinate)
  end

  test "invalid type" do
    {:ok, coordinate} = Coordinate.new(4, 6)
    assert {:error, :invalid_island_type} = Island.new(:wrong, coordinate)
  end

  test "overlaps" do
    {:ok, square_coordinate} = Coordinate.new(1,1)
    {:ok, square} = Island.new(:square, square_coordinate)
    {:ok, dot_coordinate} = Coordinate.new(1, 2)
    {:ok, dot} = Island.new(:dot, dot_coordinate)
    {:ok, l_shape_coordinate} = Coordinate.new(5,5)
    {:ok, l_shape} = Island.new(:l_shape, l_shape_coordinate)

    assert Island.overlaps?(square, dot)
    refute Island.overlaps?(square, l_shape)
    refute Island.overlaps?(dot, l_shape)
  end

  test "missed guess" do
    {:ok, dot_coordinate} = Coordinate.new(4,4)
    {:ok, dot} = Island.new(:dot, dot_coordinate)
    {:ok, guess_coordinate} = Coordinate.new(2, 2)
    assert :miss = Island.guess(dot, guess_coordinate)
  end

  test "hit guess" do
    {:ok, dot_coordinate} = Coordinate.new(4,4)
    {:ok, dot} = Island.new(:dot, dot_coordinate)
    {:hit, dot} = Island.guess(dot, dot_coordinate)
    assert Island.forested?(dot)
  end
end
