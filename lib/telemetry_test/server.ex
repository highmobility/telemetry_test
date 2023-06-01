defmodule TelemetryTest.Server do
  @moduledoc false

  use GenServer

  @spec start_link(GenServer.options()) :: GenServer.on_start()
  def start_link(options) do
    options = Keyword.merge([name: __MODULE__], options)
    {:ok, _} = GenServer.start_link(__MODULE__, nil, options)
  end

  @impl GenServer
  def init(_) do
    {:ok, %{}}
  end

  @spec push(module() | pid(), reference(), any()) :: :ok
  def push(name \\ __MODULE__, ref, args) do
    GenServer.call(name, {:push, ref, args})
  end

  @spec pop(module() | pid(), reference()) :: {:ok, term()}
  def pop(name \\ __MODULE__, ref) do
    GenServer.call(name, {:pop, ref})
  end

  @impl GenServer
  def handle_call({:push, ref, args}, _from, state) do
    new_state = Map.put(state, ref, args)
    {:reply, :ok, new_state}
  end

  def handle_call({:pop, ref}, _from, state) do
    {result, new_state} = Map.pop(state, ref)

    {:reply, {:ok, result}, new_state}
  end
end
