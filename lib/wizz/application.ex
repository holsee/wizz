defmodule Wizz.Application do
  @moduledoc false
  @app :wizz

  use Application

  def start(_type, _args) do
    children = [
      Plug.Adapters.Cowboy.child_spec(
        scheme: :http,
        plug: Wizz.Router,
        options: [
          port: Application.get_env(@app, :port),
          dispatch: dispatch()
        ]
      )
    ]

    opts = [strategy: :one_for_one, name: Wizz.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp dispatch do
    [
      {:_,
       [
         {"/ws", Wizz.SocketHandler, []},
         {:_, Plug.Adapters.Cowboy.Handler, {Wizz.Router, []}}
       ]}
    ]
  end
end
