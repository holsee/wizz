defmodule WebSocketClient do
  @moduledoc """
  Generic WebSocket Client Process.

  Support asychronous receipt of packets passing to the implementing modules `handle_packet/2`
  callback implementation.
  """
  use GenServer

  require Logger

  @callback handle_packet(Socket.Web.packet(), state :: term()) :: {:noreply, state :: term()}

  defmacro __using__(opts) do
    quote do
      @behaviour WebSocketClient

      defdelegate send(ref, packet), to: WebSocketClient

      def start_link(uri) do
        WebSocketClient.start_link(__MODULE__, uri)
      end
    end
  end

  def start_link(impl, url) do
    uri = URI.parse(url)
    secure = uri.scheme == "https"

    case Socket.Web.connect(uri.host, uri.port, path: uri.path, secure: secure) do
      {:ok, conn} ->
        GenServer.start_link(__MODULE__, impl: impl, conn: conn)

      {:error, _} = err ->
        err
    end
  end

  def send(ref, packet) do
    GenServer.cast(ref, {:send, packet})
  end

  ##
  # GenServer callbacks

  def init(args) do
    Logger.debug("state: #{inspect(args)}")

    state = args |> Enum.into(%{})

    # schedule async receive loop
    recv_loop(self())
    {:ok, state}
  end

  def handle_cast({:send, {type, msg} = packet}, state) do
    Logger.debug("Sending #{type} frame with payload: #{msg}")
    Socket.Web.send(state.conn, packet)
    {:noreply, state}
  end

  def handle_cast({:handle_packet, packet}, state) do
    # delegate handling of packet message to @callback
    state.impl.handle_packet(packet, state)
  end

  def handle_cast(:recv, state) do
    receive_packet(self(), state.conn)
    {:noreply, state}
  end

  ##
  # Receiving Packets Asynchronously
  #
  # Continuously receive on another linked process
  # When a message is received, sending it back to
  # client process to be handled.

  defp recv_loop(ref) do
    GenServer.cast(ref, :recv)
  end

  defp packet_received(ref, packet) do
    GenServer.cast(ref, {:handle_packet, packet})
  end

  defp receive_packet(ref, conn) do
    Task.start_link(fn ->
      case Socket.Web.recv(conn) do
        {:ok, packet} ->
          packet_received(ref, packet)

        {:error, error} ->
          Logger.error("Error Receving from Socket: #{inspect(error)}")
      end

      # When message received, loop.
      recv_loop(ref)
    end)

    :ok
  end
end
