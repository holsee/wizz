defmodule Wizz.SocketHandler do
  require Logger

  # See: https://ninenines.eu/docs/en/cowboy/2.2/manual/cowboy_websocket/

  def init(_, _req, _opts) do
    {:upgrade, :protocol, :cowboy_websocket}
  end

  # terminate if no activity for one minute
  @timeout 60000

  # Called on websocket connection initialization.
  def init(req, state) do
    Logger.debug("init #{inspect(state)}")
    {:cowboy_websocket, req, state}
  end

  # Handle 'ping' messages from the browser - reply
  def websocket_handle({:text, "ping"}, state) do
    Logger.debug("received: ping; sending: pong")
    {:reply, {:text, "pong"}, state}
  end

  # Handle other messages from the browser - don't reply
  def websocket_handle({:text, message}, state) do
    Logger.debug("received: #{message}")
    {:ok, state}
  end

  # Format and forward elixir messages to client
  def websocket_info(message, state) do
    {:reply, {:text, message}, state}
  end

  # No matter why we terminate, remove all of this pids subscriptions
  def terminate(_reason, _partial_req, _state) do
    Logger.debug("terminated!")
    :ok
  end
end
