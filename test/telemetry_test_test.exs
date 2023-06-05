defmodule TelemetryTestTest do
  use ExUnit.Case, async: false
  doctest TelemetryTest

  alias TelemetryTest, as: SUT
  import SUT

  setup do
    %{foo: :bar, it_keeps_context: :it_does}
  end

  describe "telemetry_listen/1" do
    setup [:telemetry_listen]

    @tag telemetry_listen: [:sample, :event]
    test "sends telemetry event to test process", context do
      :telemetry.execute([:sample, :event], %{sample_measurement: true}, %{sample_metadata: true})

      assert_receive {:telemetry_event,
                      %{
                        event: [:sample, :event],
                        measurements: %{sample_measurement: true},
                        metadata: %{sample_metadata: true}
                      }}

      assert context.foo == :bar
    end

    @tag telemetry_listen: [:sample, :event]
    test "sends telemetry event to test process even when code runs outside test process",
         context do
      spawn(fn ->
        :telemetry.execute([:sample, :event], %{sample_measurement: true}, %{
          sample_metadata: true
        })
      end)

      assert_receive {:telemetry_event,
                      %{
                        event: [:sample, :event],
                        measurements: %{sample_measurement: true},
                        metadata: %{sample_metadata: true}
                      }}

      assert context.foo == :bar
    end

    @tag telemetry_listen: {[:sample, :event], &__MODULE__.test_callback/1}
    test "executes given function after test run", context do
      :telemetry.execute([:sample, :event], %{sample_measurement: true}, %{sample_metadata: true})

      assert context.foo == :bar
    end

    @tag telemetry_listen: [
           [:sample, :event, :one],
           [:sample, :event, :two],
           [:sample, :event, :one]
         ]
    test "sends telemetry events to test process", context do
      :telemetry.execute([:sample, :event, :one], %{sample_measurement: true, n: 1}, %{
        sample_metadata: true
      })

      :telemetry.execute([:sample, :event, :two], %{sample_measurement: true, n: 2}, %{
        sample_metadata: true
      })

      assert_receive {:telemetry_event,
                      %{
                        event: [:sample, :event, :one],
                        measurements: %{sample_measurement: true, n: 1},
                        metadata: %{sample_metadata: true}
                      }}

      assert_receive {:telemetry_event,
                      %{
                        event: [:sample, :event, :one],
                        measurements: %{sample_measurement: true, n: 1},
                        metadata: %{sample_metadata: true}
                      }}

      assert_receive {:telemetry_event,
                      %{
                        event: [:sample, :event, :two],
                        measurements: %{sample_measurement: true, n: 2},
                        metadata: %{sample_metadata: true}
                      }}

      assert context.foo == :bar
    end

    @tag telemetry_listen: [
           {[:sample, :event, :one], &__MODULE__.test_callback_one/1},
           {[:sample, :event, :two], &__MODULE__.test_callback_two/1},
           {[:sample, :event, :one], &__MODULE__.test_callback_one/1}
         ]
    test "executes given functions after test run", context do
      :telemetry.execute([:sample, :event, :one], %{sample_measurement: true, n: 1}, %{
        sample_metadata: true
      })

      :telemetry.execute([:sample, :event, :two], %{sample_measurement: true, n: 2}, %{
        sample_metadata: true
      })

      assert context.foo == :bar
    end

    @tag telemetry_listen: [
           {[:sample, :event, :one], {__MODULE__, :test_callback_one_mfa, _args = [:other_args]}},
           {[:sample, :event, :two], {__MODULE__, :test_callback_two_mfa, _args = [:other_args]}},
           {[:sample, :event, :one], {__MODULE__, :test_callback_one_mfa, _args = [:other_args]}}
         ]
    test "executes given MFA after test run", context do
      :telemetry.execute([:sample, :event, :one], %{sample_measurement: true, n: 1}, %{
        sample_metadata: true
      })

      :telemetry.execute([:sample, :event, :two], %{sample_measurement: true, n: 2}, %{
        sample_metadata: true
      })

      assert context.foo == :bar
    end

    def test_callback(telemetry) do
      assert %{
               event: [:sample, :event],
               measurements: %{sample_measurement: true},
               metadata: %{sample_metadata: true}
             } = telemetry
    end

    def test_callback_one(telemetry) do
      assert %{
               event: [:sample, :event, :one],
               measurements: %{sample_measurement: true, n: 1},
               metadata: %{sample_metadata: true}
             } = telemetry
    end

    def test_callback_two(telemetry) do
      assert %{
               event: [:sample, :event, :two],
               measurements: %{sample_measurement: true, n: 2},
               metadata: %{sample_metadata: true}
             } = telemetry
    end

    def test_callback_one_mfa(telemetry, :other_args) do
      test_callback_one(telemetry)
    end

    def test_callback_two_mfa(telemetry, :other_args) do
      test_callback_two(telemetry)
    end

    test "works when tags are not set", context do
      assert context.foo == :bar
    end
  end
end
