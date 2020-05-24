defmodule Oscarex.Snac.Icq do
  @moduledoc """
  ICQ-specific extensions
  """

  use Oscarex.Snac.Base,
    byte_id: 0x15,
    bidi_messages: [
      offline_message: 0x00F0,
      offline_message_complete: 0x00F1,
      info: 0x00F2,
      alias: 0x00F3
    ]
end
