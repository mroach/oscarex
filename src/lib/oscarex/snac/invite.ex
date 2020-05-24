defmodule Oscarex.Snac.Invite do
  @moduledoc """
  Invitation service
  """

  use Oscarex.Snac.Base,
    byte_id: 0x06,
    client_messages: [invite_friend: 0x02],
    server_messages: [invite_friend_acl: 0x03]
end
