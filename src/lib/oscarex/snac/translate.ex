defmodule Oscarex.Snac.Translate do
  @moduledoc """
  Translation service
  """

  use Oscarex.Snac.Base,
    byte_id: 0x0C,
    messages: [
      error: 0x01,
      request: 0x02,
      reply: 0x03,
      default: 0xFFFF
    ]
end
