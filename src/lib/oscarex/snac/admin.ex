defmodule Oscarex.Snac.Admin do
  @moduledoc """
  Administrative services
  """

  use Oscarex.Snac.Base,
    byte_id: 0x07,
    client_messages: [
      request_account_info: 0x02,
      change_account: 0x04,
      account_confirm: 0x06,
      delete_account: 0x08
    ],
    server_messages: [
      account_info: 0x03,
      change_account_ack: 0x05,
      account_confirm_ack: 0x07,
      delete_account_ack: 0x09
    ]
end
