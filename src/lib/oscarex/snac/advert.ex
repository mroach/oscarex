defmodule Oscarex.Snac.Advert do
  @moduledoc """
  Advertisement services
  """

  use Oscarex.Snac.Base,
    byte_id: 0x05,
    client_messages: [request_ads: 0x02],
    server_messages: [ads_reply: 0x03]
end
