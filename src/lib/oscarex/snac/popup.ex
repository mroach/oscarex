defmodule Oscarex.Snac.Popup do
  @moduledoc """
  Popup notices service
  """

  use Oscarex.Snac.Base,
    byte_id: 0x08,
    client_messages: [display_popup_message: 0x02]
end
