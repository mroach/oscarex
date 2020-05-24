defmodule Oscarex.Snac.Chat do
  @moduledoc """
  Chat service
  """

  use Oscarex.Snac.Base,
    byte_id: 0x0E,
    client_messages: [
      outgoing_message: 0x05,
      evil_request: 0x07
    ],
    server_messages: [
      room_info_update: 0x02,
      user_join: 0x03,
      user_leave: 0x04,
      incoming_message: 0x06,
      evil_reply: 0x08
    ],
    bidi_messages: [
      chat_error: 0x09
    ]
end
