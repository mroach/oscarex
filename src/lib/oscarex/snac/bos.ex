defmodule Oscarex.Snac.Bos do
  @moduledoc """
  Basic Oscar Services
  """

  use Oscarex.Snac.Base,
    byte_id: 0x09,
    client_messages: [
      request_params: 0x02,
      set_group_permissions: 0x04,
      add_to_visibile_list: 0x05,
      delete_from_visibile_list: 0x06,
      add_to_invisibile_list: 0x07,
      delete_from_invisibile_list: 0x08
    ],
    server_messages: [
      params_reply: 0x03,
      service_error: 0x09
    ]
end
