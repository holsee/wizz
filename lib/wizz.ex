defmodule Wizz do
  defmodule Client do
    use WebSocketClient

    require Logger

    ##
    # API

    @doc """
    Assumes local connection, dynamically determining port and scheme
    from the server configuration.
    """
    def start_link() do
      scheme = Application.get_env(:wizz, :scheme)
      conf = Application.get_env(:wizz, :cowboy)
      port = Keyword.get(conf[scheme], :port)
      uri = "#{scheme}://localhost:#{port}/ws" |> IO.inspect()
      start_link(uri)
    end

    ##
    # Callbacks

    def handle_packet({:pong, bin}, state) do
      Logger.debug("Received pong with Message #{bin}")
      {:noreply, state}
    end

    def handle_packet({type, msg}, state) do
      Logger.debug("Received Message - Type: #{inspect(type)} -- Message: #{inspect(msg)}")
      {:noreply, state}
    end

    def handle_packet({:close, reason, msg}, state) do
      Logger.info("Received {:close, #{reason}, #{msg}} - stopping client.")
      {:stop, reason, state}
    end
  end
end
