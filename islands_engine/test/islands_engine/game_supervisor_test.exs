defmodule IslandsEngineTest.GameSupervisorTest do
  use ExUnit.Case, async: false
  alias IslandsEngine.{Game, GameSupervisor}

  test "start and stop game" do
    cassatt = "Cassatt"
    {:ok, game} = GameSupervisor.start_game(cassatt)
    via = Game.via_tuple(cassatt)
    assert :ok == GameSupervisor.stop_game(cassatt)
    refute Process.alive?(game)
    refute GenServer.whereis(via)
  end

  test "terminate callback" do
    agnes = "Agnes"
    {:ok, game} = GameSupervisor.start_game(agnes)
    GameSupervisor.stop_game(agnes)
    refute Process.alive?(game)
    via = Game.via_tuple(agnes)
    refute GenServer.whereis(via)
    assert [] == :ets.lookup(:game_state, agnes)
  end
end
