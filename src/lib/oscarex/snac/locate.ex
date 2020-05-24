defmodule Oscarex.Snac.Locate do
  @moduledoc """
  Location services
  """

  use Oscarex.Snac.Base,
    byte_id: 0x02,
    client_messages: [
      request_rights: 0x02,
      set_user_info: 0x04,
      request_user_info: 0x05,
      watcher_sub_request: 0x07,
      update_dir_info_request: 0x09,
      snac_query: 0x0B,
      update_interests: 0x0F,
      user_info_query: 0x15
    ],
    server_messages: [
      rights_info: 0x03,
      user_info: 0x06,
      watcher_notification: 0x08,
      update_dir_info_reply: 0x0A,
      snac_query_reply: 0x0C,
      update_interests_reply: 0x10
    ]
end
