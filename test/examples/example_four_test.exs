defmodule ExampleFour do
  def hello do
    :telemetry.span([:sample, :event, :example_four], %{sample_metadata: true}, fn ->
      {:there, %{more_metadata: true}}
    end)
  end
end

defmodule ExampleFourTest do
  use ExUnit.Case, async: false

  import TelemetryTest

  setup [:telemetry_listen]

  @tag telemetry_listen: [
         {[:sample, :event, :example_four, :start], &__MODULE__.test_start_callback/1},
         {[:sample, :event, :example_four, :stop], &__MODULE__.test_stop_callback/1}
       ]
  test "match on telemetry events" do
    assert :there = ExampleFour.hello()
  end

  def test_start_callback(telemetry) do
    assert %{
             event: [:sample, :event, :example_four, :start],
             measurements: %{monotonic_time: _, system_time: _},
             metadata: %{sample_metadata: true, telemetry_span_context: _}
           } = telemetry
  end

  def test_stop_callback(telemetry) do
    assert %{
             event: [:sample, :event, :example_four, :stop],
             measurements: %{monotonic_time: _, duration: _},
             metadata: %{more_metadata: true, telemetry_span_context: _}
           } = telemetry
  end
end
