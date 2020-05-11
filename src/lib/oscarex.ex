defmodule Oscarex do
  @moduledoc """
  Documentation for `Oscarex`.
  """

  @flap_header 0x2A

  @snac_family_oservice 0x0001
  @snac_family_locate 0x0002
  @snac_family_buddy 0x0003
  @snac_family_icbm 0x0004
  @snac_family_advert 0x0005
  @snac_family_invite 0x0006
  @snac_family_admin 0x0007
  @snac_family_popup 0x0008
  @snac_family_bos 0x0009
  @snac_family_userlookup 0x000A
  @snac_family_stats 0x000B
  @snac_family_translate 0x000C
  @snac_family_chatnav 0x000D
  @snac_family_chat 0x000E
  @snac_family_odir 0x000F
  @snac_family_bart 0x0010
  @snac_family_feedbag 0x0013
  @snac_family_icq 0x0015
  @snac_family_auth 0x0017
  @snac_family_alert 0x0018

  @snac_subtype_auth_error 0x0001
  @snac_subtype_auth_loginreqest 0x0002
  @snac_subtype_auth_loginresponse 0x0003
  @snac_subtype_auth_authreq 0x0006
  @snac_subtype_auth_authresponse 0x0007
  @snac_subtype_auth_securid_request 0x000A
  @snac_subtype_auth_securid_response 0x000B

  def parse_message_string(message) when is_binary(message) do
    message |> String.split(~r/\s+/, trim: true) |> parse_message_string()
  end

  def parse_message_string(hex_bytes) when is_list(hex_bytes) do
    hex_bytes
    |> Enum.map(&String.upcase/1)
    |> Enum.map(&Base.decode16!/1)
    |> :binary.list_to_bin()
    |> parse_message_bin()
  end

  def parse_message_bin(
        <<@flap_header, chan::integer, seq::integer-size(16), dsize::integer-size(16),
          data::bitstring>>
      ) do
    %{
      channel: chan,
      sequence_number: seq,
      data_length: dsize,
      raw_data: data,
      snac: parse_snac(data)
    }
  end

  def parse_snac(
        <<family::integer-size(16), subtype::integer-size(16), flags::integer-size(16),
          reqid::integer-size(32), tlvs::bitstring>>
      ) do
    %{
      family: family,
      subtype: subtype,
      flags: flags,
      request_id: reqid,
      tlvs:
        tlvs
        |> parse_tlv()
        |> Enum.map(fn %{type: type, data: data} ->
          key =
            case tlv_type(family, subtype, type) do
              :unknown -> {:unknown, type}
              label -> label
            end

          {key, data}
        end)
    }
  end

  def parse_tlv(<<type::integer-size(16), dsize::integer-size(16), rest::bitstring>>) do
    <<data::binary-size(dsize), next::bitstring>> = rest
    [%{type: type, size: dsize, data: data} | parse_tlv(next)]
  end

  def parse_tlv(""), do: []

  defp tlv_type(@snac_family_auth, @snac_subtype_auth_loginreqest, 0x01), do: :screen_name
  defp tlv_type(@snac_family_auth, @snac_subtype_auth_loginreqest, 0x03), do: :client_id_string
  defp tlv_type(@snac_family_auth, @snac_subtype_auth_loginreqest, 0x25), do: :md5_password_hash
  defp tlv_type(@snac_family_auth, @snac_subtype_auth_loginreqest, 0x14), do: :distribution_number
  defp tlv_type(@snac_family_auth, @snac_subtype_auth_loginreqest, 0x16), do: :client_id_number

  defp tlv_type(@snac_family_auth, @snac_subtype_auth_loginreqest, 0x17),
    do: :client_major_version

  defp tlv_type(@snac_family_auth, @snac_subtype_auth_loginreqest, 0x18),
    do: :client_minor_version

  defp tlv_type(@snac_family_auth, @snac_subtype_auth_loginreqest, 0x19),
    do: :client_patch_version

  defp tlv_type(@snac_family_auth, @snac_subtype_auth_loginreqest, 0x1A),
    do: :client_build_version

  defp tlv_type(@snac_family_auth, @snac_subtype_auth_loginreqest, 0x0F), do: :client_language
  defp tlv_type(@snac_family_auth, @snac_subtype_auth_loginreqest, 0x0E), do: :client_country

  defp tlv_type(_, _, _), do: :unknown
end
