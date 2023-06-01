defmodule TelemetryTest.ServerTest do
  use ExUnit.Case, async: false

  alias TelemetryTest.Server, as: SUT

  describe "push and pop" do
    test "pushes and pops value by reference" do
      name = :FooBarTestServer
      {:ok, _pid} = SUT.start_link(_opts = [name: name])

      ref = make_ref()

      assert :ok = SUT.push(name, ref, :this_is_a_value)
      assert {:ok, :this_is_a_value} = SUT.pop(name, ref)

      :ok = GenServer.stop(name)
    end
  end
end
