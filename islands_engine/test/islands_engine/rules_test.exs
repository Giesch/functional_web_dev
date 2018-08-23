defmodule IslandsEngineTest.RulesTest do
  use ExUnit.Case, async: true
  alias IslandsEngine.{Rules}

  test "wrong action" do
    rules = Rules.new()
    assert :error == Rules.check(rules, :non_existent_action)
  end

  test "add player" do
    rules = Rules.new()
    {:ok, rules} = Rules.check(rules, :add_player)
    assert rules.state == :players_set
  end

  test "position islands does not change the state from players_set" do
    rules = %Rules{Rules.new() | state: :players_set}
    {:ok, rules} = Rules.check(rules, {:position_islands, :player1})
    {:ok, rules} = Rules.check(rules, {:position_islands, :player2})
    assert rules.state == :players_set
  end

  test "setting islands prevents positioning islands for that player" do
    rules = %Rules{Rules.new() | state: :players_set}
    {:ok, rules} = Rules.check(rules, {:set_islands, :player1})
    assert Rules.check(rules, {:position_islands, :player1}) == :error
    assert {:ok, rules} == Rules.check(rules, {:position_islands, :player2})
    {:ok, rules} = Rules.check(rules, {:set_islands, :player2})
    assert Rules.check(rules, {:position_islands, :player2}) == :error
  end

  test "both players set islands starts the game with player 1" do
    rules = %Rules{Rules.new() | state: :players_set}
    {:ok, rules} = Rules.check(rules, {:set_islands, :player1})
    {:ok, rules} = Rules.check(rules, {:set_islands, :player2})
    assert rules.state == :player1_turn
  end

  test "guesses alternate turns and turns are enforced" do
    rules = %Rules{Rules.new() | state: :player1_turn}
    assert Rules.check(rules, {:guess_coordinate, :player2}) == :error
    assert {:ok, rules} = Rules.check(rules, {:guess_coordinate, :player1})
    assert rules.state == :player2_turn
    assert Rules.check(rules, {:guess_coordinate, :player1}) == :error
    assert {:ok, rules} = Rules.check(rules, {:guess_coordinate, :player2})
  end

  test "the game continues if there is no winner" do
    rules = %Rules{Rules.new() | state: :player1_turn}
    assert {:ok, rules} = Rules.check(rules, {:win_check, :no_win})
    assert rules.state == :player1_turn
    rules = %Rules{Rules.new() | state: :player2_turn}
    assert {:ok, rules} = Rules.check(rules, {:win_check, :no_win})
    assert rules.state == :player2_turn
  end

  test "a win ends the game" do
    rules = %Rules{Rules.new() | state: :player1_turn}
    assert {:ok, rules} = Rules.check(rules, {:win_check, :win})
    assert rules.state == :game_over
    rules = %Rules{Rules.new() | state: :player2_turn}
    assert {:ok, rules} = Rules.check(rules, {:win_check, :win})
    assert rules.state == :game_over
  end
end
