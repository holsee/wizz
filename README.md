# Wizz

Demo App to showcase using Cowboy HTTP(S) and WebSockets in Elixir & Plug.

## Change Log

* Refer to tag 1.1.x / branch cowboy-1.1.x for Cowboy 1 version.
* Updated to include configuring cowboy to use secure transport.
* Implemented secure transport for WebSockets and HTTP handler.
* Swapped `WebSockex` for `Socket` in order to ensure secure transport.
* Added Generic Server wrapper `WebSocketClient` around `Socket`.

## Configuration

### Set Transport Scheme

Edit `config/config.exs` and set scheme to `:http` or `:https`
``` elixir
config :wizz,
  scheme: :http | :https
```

## Run Server

```
$ iex -S mix
```

## Examples

### HTTPS Endpoint

Ensure `scheme` is set to `:https`.

I followed http://ezgr.net/increasing-security-erlang-ssl-cowboy/ when selecting
the secure transport options for cowboy.

Request `/ping` endpoint over `https://`:
```
$ curl https://localhost:1447/ping --cacert "./priv/ssl/cacert.crt"
pong
```

### Secure WebSocket

Same as `HTTP` examples below, except with `https://` in protocol in URI.

Note that it is also, it is possible it use `Wizz.Client.start_link/0` which
will automatically compute the websocket URI endpoint / port / scheme based
on the server configuration.

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

If we establish another connection:
```
{:ok, c} = Wizz.Client.start_link("http://localhost:1447/ws")
```

Another process is spawned to handle this connection:
```
00:00:00.157 pid=<0.289.0> module=Wizz.SocketHandler [debug] init []
```

Send `ping`:
``` elixir
Wizz.Client.send(c, {:text, "ping"})
```

_Client Log_: send `ping` message (expect `pong`):
```
00:00:00.624 pid=<0.295.0> module=WebSocketClient [debug] Sending text frame with payload: ping
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
Wizz.Client.send(c, {:text, "wow!"})
```

_Client Log_: Sending `"wow!"`
```
00:00:00.547 pid=<0.295.0> module=Wizz.Client [debug] Sending text frame with payload: wow!
```

_Server Log_: received `"wow!"`, no reply
```
00:00:00.548 pid=<0.300.0> module=Wizz.SocketHandler [debug] received: wow!
```

