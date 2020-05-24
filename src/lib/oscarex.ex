defmodule Oscarex do
  @moduledoc """
  Documentation for `Oscarex`.
  """

  alias Oscarex.{Snac, Tlv}

  @flap_header 0x2A

  @chan_new_conn 0x01
  @chan_snac_data 0x02
  @chan_flap_error 0x03
  @chan_close_conn 0x04
  @chan_keep_alive 0x05

  def parse_message(<<
        @flap_header,
        chan::integer,
        seq::integer-size(16),
        dsize::integer-size(16),
        data::bytes
      >>) do
    %{
      channel: chan,
      sequence_number: seq,
      data_length: dsize,
      raw_data: data,
      data: parse_channel_data(chan, data)
    }
  end

  # New connection negotiation
  def parse_channel_data(@chan_new_conn, <<_protover::integer-size(32), data::bytes>>) do
    Oscarex.Tlv.parse(data)
  end

  # SNAC Data
  def parse_channel_data(@chan_snac_data, data) do
    parse_snac(data)
  end

  # FLAP-level error
  def parse_channel_data(@chan_flap_error, data), do: data

  # Close connection negotiation
  def parse_channel_data(@chan_close_conn, data), do: data

  # Keep alive
  def parse_channel_data(@chan_keep_alive, data), do: data

  def parse_snac(<<
        family::integer-size(16),
        subtype::integer-size(16),
        flags::integer-size(16),
        reqid::integer-size(32),
        data::bytes
      >>) do
    handler = Snac.get_handler(family)

    %{
      family: Snac.get_family(family),
      subtype: Snac.get_subtype(family, subtype),
      flags: flags,
      request_id: reqid,
      raw_data: data,
      data: handler.parse_data(subtype, data)
    }
  end

  def parse_snac(""), do: :no_data

  def parse_snac(_), do: :invalid
end
