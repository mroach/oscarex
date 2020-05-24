defmodule Oscarex.Snac.BuddyList do
  @moduledoc """
  Buddy list management service
  """

  use Oscarex.Snac.Base,
    byte_id: 0x03,
    client_messages: [
      request_rights: 0x02,
      add_buddy: 0x04,
      remove_buddy: 0x05,
      request_watchers: 0x06,
      watcher_sub_request: 0x08
    ],
    server_messages: [
      rights_info: 0x03,
      watchers_list: 0x07,
      watcher_notification: 0x09,
      rejected: 0x0A,
      signing_on: 0x0B,
      signing_off: 0x0C
    ]
end
