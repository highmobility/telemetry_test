# Telemetry Test

Telemetry Test is an Elixir library designed to simplify and reduce test clutter when testing Telemetry events. It provides a convenient way to set up Telemetry event listeners, enabling you to write cleaner and more expressive tests for your Telemetry-powered applications.

## Introduction

Telemetry is a powerful framework in Elixir that allows you to instrument your code and collect valuable runtime data. However, when it comes to testing Telemetry events, the process can become verbose and cluttered, leading to complex test code and reduced readability. This library aims to address this challenge by providing a set of utilities that streamline the testing process, making it easier and more enjoyable.

## Key Features

### Simplified Event Setup

You can set up Telemetry event listeners with just a few lines of code. Instead of manually attaching and detaching event handlers, the library provides functions that handle this process automatically, reducing boilerplate code in your tests.

### Reduced Test Clutter

By abstracting away the setup for Telemetry events, it significantly reduces test clutter. Your test code becomes cleaner, more focused, and easier to understand, improving maintainability and reducing the cognitive load when working with Telemetry-based tests.

### Multiple Event Listening Options

It supports various options for listening to Telemetry events. You can listen for specific events using using the event names, match events with custom callbacks and even listen to multiple events.


## Getting Started

To start using the Telemetry Test Helper in your Elixir project, follow these steps:

1. Add the `telemetry_test_helper` dependency to your `mix.exs` file:

```elixir
defp deps do
  [
    {:telemetry_test, "~> 1.0"}
  ]
end
```

2. Run `mix deps.get` to fetch the new dependency.

3. Ensure that the Telemetry events you want to test are properly instrumented in your application or library.

4. In your test module or TestCase, import the necessary functions from the library:

```elixir
defmodule MyTestModule do
  use ExUnit.Case, async: false
  import TelemetryTestHelper
end
```

5. Write your tests by utilizing the library functions. Set up event listeners and perform assertions on received events to validate the behavior of your code.

```elixir
defmodule MyTestModule do
  use ExUnit.Case, async: false
  import TelemetryTest

  setup [:telemetry_listen]

  @tag telemetry_listen: [:sample, :event, :example_one]
  test "match on telemetry event" do
    # Execute the code that will emit the telemetry event
    assert :there = ExampleOne.hello()

    # your test process will receive a message with Telemetry event
    assert_receive {:telemetry_event,
                    %{
                      event: [:sample, :event, :example_one],
                      measurements: %{sample_value: :hello_there},
                      metadata: %{sample_metadata: true}
                    }}
  end
end
```

6. Run your tests with `mix test` and observe the improved clarity and simplicity in your Telemetry event tests.


## Examples

To help you understand how to use the Telemetry Test, we provide a collection of examples in the [Telemetry Test GitHub repository](https://github.com/highmobility/telemetry_test/tree/main/test/examples). These examples demonstrate different scenarios and use cases, showcasing the capabilities of the library and providing practical guidance for writing effective Telemetry event tests.
