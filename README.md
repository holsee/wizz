# Wizz

An app demontrating how to use cowboy websockets via Plug in elixir.

*Updated for Cowboy 2.2.x* - See: branch cowboy-1.1.x for Cowboy 1 version

## Configuration

### Set Port

config/config.exs
```
config :wizz,
  port: 1447
```

## Examples

### HTTP Endpoint

```
$ curl http://localhost:1447/ping
pong
```

```
$ curl http://localhost:1447/other
¯\_(ツ)_/¯ 404
```

### WebSocket

I have included a websocket client module to demonstrating connecting to the
websocket endpoint: `Wizz.Client`.

Start Server with Console:
```
$ iex -S mix
```

Create a WebSocket connection (spawn a client process):
``` elixir
# Establish WebSocket Connection
{:ok, client} = Wizz.Client.start_link("http://localhost:1447/ws")
```

Debug Log showing `SocketHandler` process spawned:
```
00:00:00.000 pid=<0.324.0> module=Wizz.SocketHandler [debug] websocket_init :tcp, []
```

```
{:ok, client} = Wizz.Client.start_link("http://localhost:1447/ws")
```

```
16:23:33.041 pid=<0.300.0> module=Wizz.SocketHandler [debug] websocket_init :tcp, []
```

Send `ping`:
``` elixir
Wizz.Client.ping(c)
```

_Client Log_: send `ping` message (expect `pong`):
```
00:00:00.624 pid=<0.295.0> module=Wizz.Client [debug] Sending text frame with payload: ping
```

_Server Log_: `ping` received, sending `pong`:
```
00:00:00.624 pid=<0.300.0> module=Wizz.SocketHandler [debug] received: ping; sending: pong
```

_Client Log_: received `pong`
```
00:00:00.626 pid=<0.295.0> module=Wizz.Client [debug] Received Message - Type: :text -- Message: "pong"
```

Send arbitrary message:

``` elixir
Wizz.Client.send(c, "wow!")
```

_Client Log_: Sending `"wow!"`
```
16:23:51.547 pid=<0.295.0> module=Wizz.Client [debug] Sending text frame with payload: wow!
```

_Server Log_: received `"wow!"`, no reply
```
16:23:51.547 pid=<0.300.0> module=Wizz.SocketHandler [debug] received: wow!
```

