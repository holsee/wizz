defmodule Wizz.Application do
  @moduledoc false
  @app :wizz

  use Application

  require Logger

  def start(_type, _args) do
    cowboy_opts = Application.get_env(@app, :cowboy) |> IO.inspect
    children = [
      Plug.Adapters.Cowboy2.child_spec(
        scheme: Keyword.get(cowboy_opts, :scheme),
        plug: Wizz.Router,
        options: cowboy_opts
      )
    ]

    Logger.info("Application started.")

    opts = [strategy: :one_for_one, name: Wizz.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
