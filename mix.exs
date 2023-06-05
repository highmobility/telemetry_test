defmodule TelemetryTest.MixProject do
  use Mix.Project

  def project do
    [
      app: :telemetry_test,
      version: "0.1.1",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      docs: docs()
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
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/highmobility/telemetry_test"}
    }
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md"]
    ]
  end

  defp deps do
    [
      {:telemetry, "~> 1.2"},
      {:ex_doc, "~> 0.29.4", only: :dev, runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test]}
    ]
  end
end
