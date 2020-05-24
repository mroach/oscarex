defmodule Oscarex.Snac.ChatNavigation do
  @moduledoc """
  Chat navigation service
  """

  use Oscarex.Snac.Base,
    byte_id: 0x0D,
    client_messages: [
      request_limits: 0x02,
      request_exchange_info: 0x03,
      request_room_info: 0x04,
      request_ext_room_info: 0x05,
      request_member_list: 0x06,
      room_search: 0x07,
      create_room: 0x08
    ],
    server_messages: [
      info_response: 0x09
    ]
end
