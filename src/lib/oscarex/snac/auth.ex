defmodule Oscarex.Snac.Auth do
  @moduledoc """
  Authentication and registration service
  """

  use Oscarex.Snac.Base,
    byte_id: 0x17,
    client_messages: [
      login_request: 0x02,
      new_uni_request: 0x04,
      auth_request: 0x06,
      securid_response: 0x0B
    ],
    server_messages: [
      login_response: 0x03,
      new_uin_response: 0x05,
      auth_response: 0x07,
      securid_request: 0x0A
    ]

  def parse_data(0x07, <<len::integer-size(16), key::bitstring>>) do
    %{auth_key: key}
  end

  def parse_data(_, data), do: Oscarex.Tlv.parse(data)
end
