defmodule IslandsEngineTest.GameTest do
  use ExUnit.Case, async: false
  alias IslandsEngine.{Coordinate, Game, Rules}

  test "init" do
    {:ok, game} = Game.start_link("Frank")
    state_data = :sys.get_state(game)
    assert "Frank" == state_data.player1.name
  end

  test "add player" do
    {:ok, game} = Game.start_link("frank")
    assert :ok = Game.add_player(game, "dweezil")
    state_data = :sys.get_state(game)
    assert state_data.player2.name == "dweezil"
  end

  test "position island" do
    {:ok, game} = Game.start_link("Fred")
    assert :ok == Game.add_player(game, "Wilma")
    state_data = :sys.get_state(game)
    assert state_data.rules.state == :players_set
    assert :ok == Game.position_island(game, :player1, :square, 1, 1)
    state_data = :sys.get_state(game)

    {:ok, c1} = Coordinate.new(1, 1)
    {:ok, c2} = Coordinate.new(1, 2)
    {:ok, c3} = Coordinate.new(2, 1)
    {:ok, c4} = Coordinate.new(2, 2)
    expected_coordinates = MapSet.new([c1, c2, c3, c4])

    assert expected_coordinates == state_data.player1.board.square.coordinates
    assert {:error, :invalid_coordinate} = Game.position_island(game, :player1, :dot, 12, 1)
  end

  test "guess coordinate" do
    {:ok, game} = Game.start_link("Miles")
    assert :error == Game.guess_coordinate(game, :player1, 1, 1)
    assert :ok == Game.add_player(game, "Trane")
    assert :ok == Game.position_island(game, :player1, :dot, 1, 1)
    # TODO: make this use the actual workflow
    :sys.replace_state(game, fn state_data ->
      %{state_data | rules: %Rules{state: :player1_turn}}
    end)

    assert {:miss, :none, :no_win} == Game.guess_coordinate(game, :player1, 5, 5)
    assert :error == Game.guess_coordinate(game, :player1, 3, 1)
    assert {:hit, :dot, :win} == Game.guess_coordinate(game, :player2, 1, 1)
  end
end
