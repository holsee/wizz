defmodule Wizz.Application do
  @moduledoc false
  @app :wizz

  use Application

  require Logger

  def start(_type, _args) do

    scheme = Application.get_env(@app, :scheme)
    options = Application.get_env(@app, :cowboy)

    children = [
      Plug.Adapters.Cowboy2.child_spec(
        scheme: scheme,
        plug: Wizz.Router,
        options: options[scheme]
      )
    ]

    Logger.info("Application started, using #{scheme}.")

    opts = [strategy: :one_for_one, name: Wizz.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
