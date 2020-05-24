defmodule Oscarex.Snac.BuddyIcon do
  @moduledoc """
  Server-stored buddy icons (SSBI) service
  """

  use Oscarex.Snac.Base,
    byte_id: 0x10,
    client_messages: [
      upload_icon: 0x02,
      request_aim: 0x04,
      request_icq: 0x06
    ],
    server_messages: [
      upload_icon_ack: 0x03,
      response_aim: 0x05,
      response_icq: 0x07
    ]
end
