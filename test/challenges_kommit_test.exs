defmodule ChallengeTest do
  use ExUnit.Case
  doctest Challenge

  test "Solve the cases" do
    assert Challenge.solve_cases() == :ok
  end
end
