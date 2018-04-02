defmodule Wizz.Router do
  use Plug.Router

  plug(Plug.SSL)
  plug(Plug.Logger)
  plug(Plug.RequestId)
  plug(:match)
  plug(:dispatch)

  get "/ping" do
    send_resp(conn, 200, "pong")
  end

  match _ do
    send_resp(conn, 404, "¯\\_(ツ)_/¯ 404")
  end
end
