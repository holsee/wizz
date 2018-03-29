# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :logger, :console, metadata: [:request_id, :pid, :module]

config :wizz, port: 1447
