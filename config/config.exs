# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :logger, :console, metadata: [:request_id, :pid, :module]

config :wizz, scheme: :http

dispatch = [
  _: [
    {"/ws", Wizz.SocketHandler, []},
    {:_, Plug.Adapters.Cowboy2.Handler, {Wizz.Router, []}}
  ]
]

config :wizz, :cowboy,
  http: [
    port: 1447,
    dispatch: dispatch
  ],
  https: [
    # See: http://ezgr.net/increasing-security-erlang-ssl-cowboy/
    port: 1447,
    dispatch: dispatch,
    # Set `otp_app` when using relative path to certs
    otp_app: :wizz,
    cacertfile: "priv/ssl/cacert.crt",
    certfile: "priv/ssl/server_crt.pem",
    keyfile: "priv/ssl/server_key.pem",
    dhfile: "priv/ssl/dh-params.pem",
    versions: [:"tlsv1.2", :"tlsv1.1", :tlsv1],
    ciphers: [
      'ECDHE-ECDSA-AES256-GCM-SHA384',
      'ECDHE-RSA-AES256-GCM-SHA384',
      'ECDHE-ECDSA-AES256-SHA384',
      'ECDHE-RSA-AES256-SHA384',
      'ECDHE-ECDSA-DES-CBC3-SHA',
      'ECDH-ECDSA-AES256-GCM-SHA384',
      'ECDH-RSA-AES256-GCM-SHA384',
      'ECDH-ECDSA-AES256-SHA384',
      'ECDH-RSA-AES256-SHA384',
      'DHE-DSS-AES256-GCM-SHA384',
      'DHE-DSS-AES256-SHA256',
      'AES256-GCM-SHA384',
      'AES256-SHA256',
      'ECDHE-ECDSA-AES128-GCM-SHA256',
      'ECDHE-RSA-AES128-GCM-SHA256',
      'ECDHE-ECDSA-AES128-SHA256',
      'ECDHE-RSA-AES128-SHA256',
      'ECDH-ECDSA-AES128-GCM-SHA256',
      'ECDH-RSA-AES128-GCM-SHA256',
      'ECDH-ECDSA-AES128-SHA256',
      'ECDH-RSA-AES128-SHA256',
      'DHE-DSS-AES128-GCM-SHA256',
      'DHE-DSS-AES128-SHA256',
      'AES128-GCM-SHA256',
      'AES128-SHA256',
      'ECDHE-ECDSA-AES256-SHA',
      'ECDHE-RSA-AES256-SHA',
      'DHE-DSS-AES256-SHA',
      'ECDH-ECDSA-AES256-SHA',
      'ECDH-RSA-AES256-SHA',
      'AES256-SHA',
      'ECDHE-ECDSA-AES128-SHA',
      'ECDHE-RSA-AES128-SHA',
      'DHE-DSS-AES128-SHA',
      'ECDH-ECDSA-AES128-SHA',
      'ECDH-RSA-AES128-SHA',
      'AES128-SHA'
    ],
    secure_renegotiate: true,
    reuse_sessions: true,
    honor_cipher_order: true
  ]
