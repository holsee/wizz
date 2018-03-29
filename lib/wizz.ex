defmodule Wizz do
  defmodule Client do
    use WebSockex

    require Logger

    def ping(client) do
      WebSockex.cast(client, {:send, {:text, "ping"}})
    end

    def send(client, msg) when is_binary(msg) do
      WebSockex.cast(client, {:send, {:text, msg}})
    end

    def start_link() do
      port = Application.get_env(:wizz, :port)
      start_link("http://localhost:#{port}/ws")
    end

    def start_link(url) do
      WebSockex.start_link(url, __MODULE__, self())
    end

    def handle_frame({type, msg}, state) do
      Logger.debug("Received Message - Type: #{inspect(type)} -- Message: #{inspect(msg)}")
      {:ok, state}
    end

    def handle_cast({:send, {type, msg} = frame}, state) do
      Logger.debug("Sending #{type} frame with payload: #{msg}")
      {:reply, frame, state}
    end
  end
end
