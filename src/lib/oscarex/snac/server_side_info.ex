defmodule Oscarex.Snac.ServerSideInfo do
  @moduledoc """
  Server side information
  """

  use Oscarex.Snac.Base,
    byte_id: 0x13,
    client_messages: [
      request_rights: 0x02,
      request_data: 0x04,
      request_if_changed: 0x05,
      activate: 0x07,
      send_auth: 0x14,
      send_auth_request: 0x18,
      send_auth_reply: 0x1A
    ],
    server_messages: [
      rights_info: 0x03,
      list: 0x06,
      srv_ack: 0x0E,
      no_list: 0x0F,
      receive_auth: 0x15,
      receive_auth_request: 0x19,
      receive_auth_reply: 0x1B,
      you_were_added: 0x1C
    ],
    bidi_messages: [
      add: 0x08,
      modify: 0x09,
      delete: 0x0A,
      edit_start: 0x11,
      edit_stop: 0x12
    ]
end
