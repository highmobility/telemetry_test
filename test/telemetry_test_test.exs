defmodule TelemetryTestTest do
  use ExUnit.Case
  doctest TelemetryTest

  test "greets the world" do
    assert TelemetryTest.hello() == :world
  end
end
