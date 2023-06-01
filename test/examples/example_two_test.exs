defmodule ExampleTwo do
  def hello do
    :telemetry.execute([:sample, :event, :example_two], %{sample_value: :hello_there}, %{
      sample_metadata: true
    })

    :there
  end
end

defmodule ExampleTwoTest do
  use ExUnit.Case, async: false

  import TelemetryTest

  setup [:telemetry_listen]

  @tag telemetry_listen: {[:sample, :event, :example_two], &__MODULE__.test_callback/1}
  test "match on telemetry event" do
    assert :there = ExampleTwo.hello()
  end

  def test_callback(%{
        event: event,
        measurements: measurements,
        metadata: metadata,
        config: config
      }) do
    assert config == :this_is_a_config
    assert event == [:sample, :event, :example_two]
    assert measurements == %{sample_value: :hello_there}
    assert metadata == %{sample_metadata: true}
  end
end
