defmodule Oscarex.Snac.UserLookup do
  @moduledoc """
  User lookup service
  """

  use Oscarex.Snac.Base,
    byte_id: 0x0A,
    client_messages: [search_by_email: 0x02]
end
