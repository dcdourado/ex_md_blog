# Dependency inversion on Elixir using Ports and Adapters design pattern

## Introduction

Dependency Inversion is a well-known software development principle, described by Robert C. Martin as the responsible of systems to become flexible by making source code dependencies refer only to abstractions and not to concrete items.

![Dependency Inversion demonstrations taken from Clean Architecture book](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/exvk6d3gddlcparbb5vq.jpeg)
<center>Dependency Inversion demonstration taken from Clean Architecture book</center>

Deciding which implementation will be used in a given piece of code can be very useful and is commonly used to develop mocks on tests that involves external dependencies, such as HTTP calls or event publications.

## How it is used

On Java and other object oriented programming languages the principle can be achieved using an Interface to expose desired functions and then develop a Class to implement these signatures. On the other hand, Elixir makes it possible to apply this principle by defining a set of callbacks on a Behavior and implement them on another module following the defined specification.

We can see this pattern replicated on different open source libraries of Elixir community on many use cases:
- [Ecto database driver use-case](https://github.com/elixir-ecto/ecto/blob/master/lib/ecto/adapter.ex)
- [Swoosh mailing service use-case](https://github.com/swoosh/swoosh/blob/main/lib/swoosh/adapter.ex)
- [Tesla HTTP adapter use-case](https://github.com/elixir-tesla/tesla/blob/master/lib/tesla.ex#L125)

## Implementation example

By deriving the Dependency Inversion principle on Elixir it is possible to implement Ports and Adapters design pattern. It consists of having a Port defining the Behaviour callbacks and the functions calling the configured Adapter implementation.

Check out this quick demonstration:

```elixir
defmodule MySystem.SmsNotificationPort do
  @moduledoc """
  Sends SMS to users using configured SMS adapter.
  """

  @callback notify(user :: User.t(), message :: String.t()) :: :ok | :error

  def notify(user, message), do: impl().notify(user, message)

  defp impl, do: Application.get_env(:my_system, __MODULE__)
end

defmodule MySystem.TwillioSmsAdapter do
  @moduledoc """
  Twillio SMS adapter implementation.
  """

  @behaviour MySystem.SmsNotificationPort

  @impl true
  def notify(user, message) do
    case MySystem.HTTP.post(“http://twillio-sms.com/" <> user.phone, %{message: message}) do
      {:ok, _} -> :ok
      _ -> :error
    end
  end
end
```

And on config.exs we would setup:
```elixir
# …

config :my_system, MySystem.SmsNotificationPort,
  MySystem.TwillioSmsAdapter
```

## Conclusion

The same principle is used on Dependency Injection design pattern, given that you can use different implementations on a piece of your software. The difference is that Dependency Injection implementation is given on compile-time whilst Ports and Adapters is on **run-time**.


This means you could execute the command below on a running application and change the SMS API used on your system.
```elixir
Application.put_env(:my_system, MySystem.SmsNotificationPort, MySystem.ZenviaSmsAdapter)
```

![SMS Port implementation swap](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/g72u8rh2ibdal95mh4nf.png)

This is very powerful because now we are able to switch running implementations on the fly. For instance, if Twillio went through an outage we could change the SMS implementation Adapter to Zenvia resulting in our users having zero impact on their SMS messages. In the future, we could automatically detect outage events on a specific SMS adapter and switch to the other one, a pattern known as Circuit Breaker.
