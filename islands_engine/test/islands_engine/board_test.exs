defmodule IslandsEngineTest.BoardTest do
  use ExUnit.Case, async: true
  alias IslandsEngine.{Board, Coordinate, Island}

  test "position_island success" do
    {:ok, square_coordinate} = Coordinate.new(1,1)
    {:ok, square} = Island.new(:square, square_coordinate)
    board = Board.position_island(Board.new(), :square, square)
    assert square == board.square

    {:ok, dot_coordinate} = Coordinate.new(3,3)
    {:ok, dot} = Island.new(:dot, dot_coordinate)
    board = Board.position_island(board, :dot, dot)
    assert dot == board.dot
  end

  test "position_island failure" do
    {:ok, square_coordinate} = Coordinate.new(1,1)
    {:ok, square} = Island.new(:square, square_coordinate)
    board = Board.position_island(Board.new(), :square, square)
    {:ok, dot_coordinate} = Coordinate.new(2,2)
    {:ok, dot} = Island.new(:dot, dot_coordinate)
    assert {:error, :overlapping_island} == Board.position_island(board, :dot, dot)
  end

  test "guess miss" do
    {:ok, square_coordinate} = Coordinate.new(1,1)
    {:ok, square} = Island.new(:square, square_coordinate)
    board = Board.position_island(Board.new(), :square, square)
    {:ok, guess_coordinate} = Coordinate.new(10, 10)
    assert {:miss, :none, :no_win, board} == Board.guess(board, guess_coordinate)
  end

  test "guess hit" do
    {:ok, square_coordinate} = Coordinate.new(1,1)
    {:ok, square} = Island.new(:square, square_coordinate)
    board = Board.position_island(Board.new(), :square, square)
    {:ok, guess_coordinate} = Coordinate.new(1,1)
    assert {:hit, :none, :no_win, new_board} = Board.guess(board, guess_coordinate)
    assert MapSet.member?(new_board.square.hit_coordinates, guess_coordinate)
  end

  test "guess hit and win" do
    {:ok, square_coordinate} = Coordinate.new(1,1)
    {:ok, square} = Island.new(:square, square_coordinate)
    square = %{square | hit_coordinates: square.coordinates}
    board = Board.position_island(Board.new(), :square, square)

    {:ok, dot_coordinate} = Coordinate.new(3,3)
    {:ok, dot} = Island.new(:dot, dot_coordinate)
    board = Board.position_island(board, :dot, dot)

    {:ok, guess_coordinate} = Coordinate.new(3,3)
    assert {:hit, :dot, :win, _new_board} = Board.guess(board, guess_coordinate)
  end
end
