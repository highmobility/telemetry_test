defmodule TelemetryTest.MixProject do
  use Mix.Project

  def project do
    [
      app: :telemetry_test,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {TelemetryTest.Application, []}
    ]
  end

  defp deps do
    [
      {:telemetry, "~> 1.2"}
    ]
  end
end
