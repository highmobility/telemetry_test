defmodule TelemetryTest do
  @moduledoc """
  For example usage please refer to [test/examples](https://github.com/highmobility/telemetry_test/tree/main/test/examples) directory
  """

  use ExUnit.Case

  alias TelemetryTest.Server

  defguardp is_event(value) when is_list(value) and is_atom(hd(value))

  @doc """
  ExUnit setup callback function which attaches to telemetry events
  """
  @doc since: "0.1.0"
  def telemetry_listen(%{telemetry_listen: event, test: test_name}) when is_event(event) do
    attach_helper(test_name, event, self(), &__MODULE__.__send_to_self_handler__/4)
  end

  def telemetry_listen(%{telemetry_listen: {event_name, telemetry_listen_fn}, test: test_name})
      when is_function(telemetry_listen_fn) do
    test_ref = make_ref()

    attach_helper(test_name, event_name, test_ref, &__MODULE__.__push_handler__/4)

    on_exit(fn ->
      {:ok, result} = Server.pop(test_ref)
      telemetry_listen_fn.(result)
    end)
  end

  def telemetry_listen(%{telemetry_listen: {event_name, {mod, fun_name, args}}, test: test_name}) do
    test_ref = make_ref()

    attach_helper(test_name, event_name, test_ref, &__MODULE__.__push_handler__/4)

    on_exit(fn ->
      {:ok, result} = Server.pop(test_ref)
      apply(mod, fun_name, [result | args])
    end)
  end

  def telemetry_listen(%{telemetry_listen: matchers} = context) do
    for matcher <- matchers do
      new_context = Map.put(context, :telemetry_listen, matcher)
      telemetry_listen(new_context)
    end

    context
  end

  def telemetry_listen(context), do: context

  defp attach_helper(test_name, event_name, config, callback_fn) do
    handler_name = "#{test_name}-#{:rand.uniform()}-handler"

    :ok = :telemetry.attach(handler_name, event_name, callback_fn, config)

    on_exit(fn ->
      :ok = :telemetry.detach(handler_name)
    end)
  end

  @doc false
  # This function is only public to avoid a warning about optimization
  def __push_handler__(event, measurements, metadata, test_ref) do
    args = %{event: event, measurements: measurements, metadata: metadata}
    :ok = Server.push(test_ref, args)
  end

  @doc false
  # This function is only public to avoid a warning about optimization
  def __send_to_self_handler__(event, measurements, metadata, config_test_pid) do
    args = %{event: event, measurements: measurements, metadata: metadata}
    send(config_test_pid, {:telemetry_event, args})
  end
end
