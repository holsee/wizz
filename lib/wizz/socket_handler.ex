defmodule Wizz.SocketHandler do
  @behaviour :cowboy_websocket_handler

  require Logger

  def init(_, _req, _opts) do
    {:upgrade, :protocol, :cowboy_websocket}
  end

  # terminate if no activity for one minute
  @timeout 60000

  # Called on websocket connection initialization.
  def websocket_init(_type, req, _opts) do
    Logger.debug("websocket_init #{inspect(_type)}, #{inspect(_opts)}")
    state = %{}
    {:ok, req, state, @timeout}
  end

  # Handle 'ping' messages from the browser - reply
  def websocket_handle({:text, "ping"}, req, state) do
    Logger.debug("received: ping; sending: pong")
    {:reply, {:text, "pong"}, req, state}
  end

  # Handle other messages from the browser - don't reply
  def websocket_handle({:text, message}, req, state) do
    Logger.debug("received: #{message}")
    {:ok, req, state}
  end

  # Format and forward elixir messages to client
  def websocket_info(message, req, state) do
    {:reply, {:text, message}, req, state}
  end

  # No matter why we terminate, remove all of this pids subscriptions
  def websocket_terminate(_reason, _req, _state) do
    :ok
  end
end
