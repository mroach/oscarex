defmodule Oscarex.Snac.DirectorySearch do
  @moduledoc """
  Directory user search
  """

  use Oscarex.Snac.Base,
    byte_id: 0x0F,
    client_messages: [
      search: 0x02,
      request_interests: 0x04
    ],
    server_messages: [
      results: 0x03,
      interests_list: 0x05
    ]
end
