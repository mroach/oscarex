defmodule Oscarex.Snac.Alert do
  use Oscarex.Snac.Base,
    byte_id: 0x18,
    messages: [
      error: 0x0001,
      send_cookies: 0x0006,
      mail_status: 0x0007,
      init: 0x0016
    ]
end
