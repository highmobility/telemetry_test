defmodule TelemetryTest.MixProject do
  use Mix.Project

  def project do
    [
      app: :telemetry_test,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {TelemetryTest.Application, []}
    ]
  end

  defp description do
    "Simplify and reduce test clutter when testing Telemetry events"
  end

  defp package do
    %{
      organization: "highmobility",
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/highmobility/telemetry_test"}
    }
  end

  defp deps do
    [
      {:telemetry, "~> 1.2"},
      {:credo, "~> 1.7", only: [:dev, :test]}
    ]
  end
end
