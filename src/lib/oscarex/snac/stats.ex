defmodule Oscarex.Snac.Stats do
  @moduledoc """
  Usage stats service
  """

  use Oscarex.Snac.Base,
    byte_id: 0x0B,
    client_messages: [
      stats_report_request: 0x03
    ],
    server_messages: [
      set_report_interval: 0x02,
      stats_report_reply: 0x04
    ]
end
