defmodule TelemetryTest.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {TelemetryTest.Server, []}
    ]

    opts = [strategy: :one_for_one, name: TelemetryTest.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
