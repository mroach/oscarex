defmodule Oscarex.Tlv do
  @moduledoc """
  Type-Length-Value

  Lists of values in a data stream with a type, length of the value,
  and the value itself
  """

  @tlv_tags [
    screen_name: 0x01,
    new_password: 0x02,
    client_id_string: 0x03,
    error_description_url: 0x04,
    reconnect_address: 0x05,
    auth_cookie: 0x06,
    snac_version: 0x07,
    error_subcode: 0x08,
    disconnect_reason: 0x09,
    reconnect_hostname: 0x0A,
    url: 0x0B,
    debug_date: 0x0C,
    service_family_id: 0x0D,
    client_country: 0x0E,
    client_language: 0x0F,
    script: 0x10,
    user_email: 0x11,
    old_password: 0x12,
    registration_status: 0x13,
    distribution_number: 0x14,
    personal_text: 0x15,
    client_id_number: 0x16,
    client_major_version: 0x17,
    client_minor_version: 0x18,
    client_patch_version: 0x19,
    client_build_version: 0x1A,
    md5_password_hash: 0x25,
    latest_beta_build_number: 0x40,
    latest_beta_install_url: 0x41,
    latest_beta_info_url: 0x42,
    latest_beta_version: 0x43,
    latest_release_build_number: 0x44,
    latest_release_install_url: 0x45,
    latest_release_info_url: 0x46,
    latest_release_version: 0x47,
    beta_signature_md5: 0x48,
    release_signature_md5: 0x49,
    change_password_url: 0x54
  ]

  @doc """
  Get the TLV field label for the given byte.

  ### Example
      iex> Oscarex.Tlv.get_label(0x01)
      :screen_name
  """
  for {label, byte} <- @tlv_tags do
    def get_label(unquote(byte)), do: unquote(label)
  end

  def get_label(_), do: :unknown

  def parse(data) do
    data
    |> parse_data()
    |> Enum.map(fn
      %{type: type, data: data} ->
        case get_label(type) do
          :unknown -> {{:unknown, type}, data}
          label -> {label, data}
        end

      other ->
        other
    end)
  end

  defp parse_data(<<type::integer-size(16), dsize::integer-size(16), rest::bitstring>>) do
    case rest do
      <<data::binary-size(dsize), next::bitstring>> ->
        [%{type: type, size: dsize, data: data} | parse_data(next)]

      other ->
        [{:__parse_error, other}]
    end
  end

  defp parse_data(_), do: []
end
