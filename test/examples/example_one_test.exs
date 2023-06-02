defmodule ExampleOne do
  def hello do
    :telemetry.execute([:sample, :event, :example_one], %{sample_value: :hello_there}, %{
      sample_metadata: true
    })

    :there
  end
end

# --- TEST_BEGIN
defmodule ExampleOneTest do
  use ExUnit.Case, async: false

  import TelemetryTest

  setup [:telemetry_listen]

  @tag telemetry_listen: [:sample, :event, :example_one]
  test "match on telemetry event" do
    assert :there = ExampleOne.hello()

    assert_receive {:telemetry_event,
                    %{
                      event: [:sample, :event, :example_one],
                      measurements: %{sample_value: :hello_there},
                      metadata: %{sample_metadata: true}
                    }}
  end
end
