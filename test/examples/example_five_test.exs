defmodule ExampleFive do
  def hello do
    :telemetry.span([:sample, :event, :example_five], %{sample_metadata: true}, fn ->
      {:there, %{more_metadata: true}}
    end)
  end
end

defmodule ExampleFiveTest do
  use ExUnit.Case, async: false

  import TelemetryTest

  setup [:telemetry_listen]

  @tag telemetry_listen_many: [
         {[:sample, :event, :example_five, :start],
          {__MODULE__, :test_start_callback, _args = [:other_args]}},
         {[:sample, :event, :example_five, :stop],
          {__MODULE__, :test_stop_callback, _args = [:other_args]}}
       ]
  test "match on telemetry events" do
    assert :there = ExampleFive.hello()
  end

  def test_start_callback(
        %{
          event: event,
          measurements: measurements,
          metadata: metadata,
          config: config
        },
        :other_args
      ) do
    assert config == :this_is_a_config
    assert event == [:sample, :event, :example_five, :start]
    assert %{monotonic_time: _, system_time: _} = measurements
    assert %{sample_metadata: true, telemetry_span_context: _} = metadata
  end

  def test_stop_callback(
        %{
          event: event,
          measurements: measurements,
          metadata: metadata,
          config: config
        },
        :other_args
      ) do
    assert config == :this_is_a_config
    assert event == [:sample, :event, :example_five, :stop]
    assert %{monotonic_time: _, duration: _} = measurements
    assert %{more_metadata: true, telemetry_span_context: _} = metadata
  end
end
