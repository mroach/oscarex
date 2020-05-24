defmodule Oscarex.Snac.Oservice do
  @moduledoc """
  Generic service controls
  """

  use Oscarex.Snac.Base,
    byte_id: 0x01,
    client_messages: [
      client_ready: 0x02,
      service_request: 0x04,
      rate_info_request: 0x06,
      rate_info_ack: 0x08,
      request_self_info: 0x0E,
      set_idle: 0x11,
      set_priv_flags: 0x14,
      request_service_versions: 0x17,
      set_location_info: 0x1E,
      client_verification_reply: 0x20
    ],
    server_messages: [
      server_ready: 0x03,
      redirect: 0x05,
      rate_info: 0x07,
      rate_change: 0x0A,
      server_pause: 0x0B,
      server_resume: 0x0D,
      self_info: 0x0F,
      evil: 0x10,
      migration_request: 0x12,
      motd: 0x13,
      well_known_url: 0x15,
      nop: 0x16,
      service_versions: 0x18,
      client_verification_request: 0x1F,
      client_extended_status: 0x21
    ]

  @motd_types [
    mandatory_upgrade: 0x01,
    advisable_upgrade: 0x02,
    system_bulletin: 0x03,
    normal: 0x04,
    news: 0x05
  ]

  for {label, byte} <- @motd_types do
    def motd_type(unquote(byte)), do: unquote(label)
  end

  def parse_data(0x03, data) do
    parse_snac_families(data)
  end

  def parse_data(0x07, <<rcc::integer-size(16), data::bytes>>) do
    # rcsize_v2 = 240
    # rcsize_v1 = 280
    {rate_classes, next} = parse_list(data, rcc, &parse_rate_class/1)
    {rate_groups, next} = parse_list(next, rcc, &parse_rate_group/1)

    %{
      rate_class_count: rcc,
      rate_classes: rate_classes,
      # rate_groups: rate_groups,
      next: IO.inspect(next, limit: :infinity)
    }
  end

  def parse_data(0x13, <<type::integer-size(16), data::bytes>>) do
    %{type: motd_type(type), motd: Oscarex.Tlv.parse(data)}
  end

  def parse_data(0x16, data), do: data

  def parse_data(0x17, data) do
    parse_family_versions(data)
  end

  def parse_data(0x18, data) do
    parse_family_versions(data)
  end

  def parse_data(_, data), do: Oscarex.Tlv.parse(data)

  defp parse_snac_families(<<0x00, 0x00, rest::bytes>>) do
    parse_snac_families(rest)
  end

  defp parse_snac_families(<<family::integer-size(16), rest::bytes>>) do
    [Oscarex.Snac.get_family(family) | parse_snac_families(rest)]
  end

  defp parse_snac_families(_), do: []

  defp parse_family_versions(<<family::integer-size(16), version::integer-size(16), rest::bytes>>) do
    [{Oscarex.Snac.get_family(family), version} | parse_family_versions(rest)]
  end

  defp parse_family_versions(_), do: []

  defp parse_rate_class(<<
         id::integer-size(16),
         wsize::integer-size(32),
         clrlevel::integer-size(32),
         alevel::integer-size(32),
         limlevel::integer-size(32),
         dclevel::integer-size(32),
         currlevel::integer-size(32),
         maxlevel::integer-size(32),
         ltime::integer-size(32),
         currstate::integer-size(8),
         rest::bytes
       >>) do
    {%{
       window_size: wsize,
       clear_level: clrlevel,
       alert_level: alevel,
       limit_level: limlevel,
       disconnect_level: dclevel,
       current_level: currlevel,
       max_level: maxlevel,
       last_time: ltime,
       current_state: currstate
     }, rest}
  end

  defp parse_rate_group(<<
         id::integer-size(16),
         pair_count::integer-size(16),
         data::bytes
       >>) do
    parse_list(data, pair_count, &parse_rate_group_item/1)
  end

  defp parse_rate_group_item(<<
         fam::integer-size(16),
         stype::integer-size(16),
         rest::bytes
       >>) do
    {%{family: fam, subtype: stype}, rest}
  end

  defp parse_list(data, count, parser) do
    1..count
    |> Enum.reduce({[], data}, fn _, {acc, data} ->
      {parsed, rest} = parser.(data)
      {[parsed | acc], rest}
    end)
  end
end
