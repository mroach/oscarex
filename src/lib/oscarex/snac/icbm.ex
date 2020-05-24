defmodule Oscarex.Snac.Icbm do
  @moduledoc """
  ICBM (messages) service.

  Inter-Client Basic Message
  """

  use Oscarex.Snac.Base,
    byte_id: 0x04,
    client_messages: [
      set_params: 0x02,
      reset_params: 0x03,
      request_params: 0x04,
      send_message: 0x06,
      evil_request: 0x08
    ],
    server_messages: [
      param_info: 0x04,
      incoming_message: 0x07,
      evil_ack: 0x09,
      missed_call: 0x0A,
      message_ack: 0x0C
    ],
    bidi_messages: [
      error_data: 0x0B,
      typing_notify: 0x14
    ]
end
