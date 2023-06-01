defmodule TelemetryTest do
  use ExUnit.Case

  alias TelemetryTest.Server

  def telemetry_listen(%{
        telemetry_listen: {event_name, telemetry_listen_fn},
        test: test_name
      }) do
    test_ref = make_ref()

    attach_helper(test_name, event_name, fn event, measurements, metadata, config ->
      args = %{event: event, measurements: measurements, metadata: metadata, config: config}
      :ok = Server.push(test_ref, args)
    end)

    on_exit(fn ->
      {:ok, result} = Server.pop(test_ref)
      telemetry_listen_fn.(result)
    end)
  end

  def telemetry_listen(%{telemetry_listen: event_name, test: test_name})
      when is_list(event_name) do
    attach_helper(test_name, event_name, fn event, measurements, metadata, config ->
      args = %{event: event, measurements: measurements, metadata: metadata, config: config}
      send(self(), {:telemetry_event, args})
    end)
  end

  def telemetry_listen(%{telemetry_listen_many: matchers} = context) do
    for matcher <- matchers do
      new_context = Map.put(context, :telemetry_listen, matcher)
      telemetry_listen(new_context)
    end

    context
  end

  def telemetry_listen(context), do: context

  defp attach_helper(test_name, event_name, callback_fn) do
    handler_name = "#{test_name}-#{:rand.uniform()}-handler"

    :ok = :telemetry.attach(handler_name, event_name, callback_fn, :this_is_a_config)

    on_exit(fn ->
      :ok = :telemetry.detach(handler_name)
    end)
  end
end
