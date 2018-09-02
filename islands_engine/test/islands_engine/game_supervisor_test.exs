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
end
