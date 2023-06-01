defmodule ExampleThree do
  def hello do
    :telemetry.span([:sample, :event, :example_three], %{sample_metadata: true}, fn ->
      {:there, %{more_metadata: true}}
    end)
  end
end

defmodule ExampleThreeTest do
  use ExUnit.Case, async: false

  import TelemetryTest

  setup [:telemetry_listen]

  @tag telemetry_listen: [
         [:sample, :event, :example_three, :start],
         [:sample, :event, :example_three, :stop]
       ]
  test "match on telemetry events" do
    assert :there = ExampleThree.hello()

    assert_receive {:telemetry_event,
                    %{
                      event: [:sample, :event, :example_three, :start],
                      measurements: %{monotonic_time: _, system_time: _},
                      metadata: %{sample_metadata: true}
                    }}

    assert_receive {:telemetry_event,
                    %{
                      event: [:sample, :event, :example_three, :stop],
                      measurements: %{monotonic_time: _, duration: _},
                      metadata: %{more_metadata: true}
                    }}
  end
end
