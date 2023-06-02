defmodule ExampleFive do
  def hello do
    :telemetry.span([:sample, :event, :example_five], %{sample_metadata: true}, fn ->
      {:there, %{more_metadata: true}}
    end)
  end
end

# --- TEST_BEGIN
defmodule ExampleFiveTest do
  use ExUnit.Case, async: false

  import TelemetryTest

  setup [:telemetry_listen]

  @tag telemetry_listen: [
         {[:sample, :event, :example_five, :start],
          {__MODULE__, :test_start_callback, _args = [:other_args]}},
         {[:sample, :event, :example_five, :stop],
          {__MODULE__, :test_stop_callback, _args = [:other_args]}}
       ]
  test "match on telemetry events" do
    assert :there = ExampleFive.hello()
  end

  def test_start_callback(telemetry, :other_args) do
    assert %{
             event: [:sample, :event, :example_five, :start],
             measurements: %{monotonic_time: _, system_time: _},
             metadata: %{sample_metadata: true, telemetry_span_context: _}
           } = telemetry
  end

  def test_stop_callback(telemetry, :other_args) do
    assert %{
             event: [:sample, :event, :example_five, :stop],
             measurements: %{monotonic_time: _, duration: _},
             metadata: %{more_metadata: true, telemetry_span_context: _}
           } = telemetry
  end
end
