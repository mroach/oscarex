defmodule OscarexTest do
  use ExUnit.Case
  doctest Oscarex

  test "parses an AIM login request" do
    message = ~S"""
      2a 02 0f 57 00 95 00 17 00 02 00 00 00 00 00 00
      00 01 00 06 6d 72 6f 61 63 68 00 25 00 10 56 f3
      8f 00 8d 0a 14 5c f3 e8 8c 21 de b2 1e 86 00 03
      00 32 41 4f 4c 20 49 6e 73 74 61 6e 74 20 4d 65
      73 73 65 6e 67 65 72 20 28 53 4d 29 2c 20 76 65
      72 73 69 6f 6e 20 34 2e 33 2e 32 32 32 39 2f 57
      49 4e 33 32 00 16 00 02 01 09 00 17 00 02 00 04
      00 18 00 02 00 03 00 19 00 02 00 00 00 1a 00 02
      08 b5 00 14 00 04 00 00 00 92 00 0f 00 02 65 6e
      00 0e 00 02 75 73 00 4a 00 01 01
    """

    assert %{
             channel: 2,
             data_length: 149,
             raw_data: _data,
             sequence_number: 3927,
             snac: %{
               family: 23,
               flags: 0,
               request_id: 0,
               subtype: 2,
               tlvs: [
                 {:screen_name, "mroach"},
                 {:md5_password_hash,
                  <<86, 243, 143, 0, 141, 10, 20, 92, 243, 232, 140, 33, 222, 178, 30, 134>>},
                 {:client_id_string, "AOL Instant Messenger (SM), version 4.3.2229/WIN32"},
                 {:client_id_number, <<1, 9>>},
                 {:client_major_version, <<0, 4>>},
                 {:client_minor_version, <<0, 3>>},
                 {:client_patch_version, <<0, 0>>},
                 {:client_build_version, <<8, 181>>},
                 {:distribution_number, <<0, 0, 0, 146>>},
                 {:client_language, "en"},
                 {:client_country, "us"},
                 {{:unknown, 74}, <<1>>}
               ]
             }
           } = Oscarex.parse_message_string(message)
  end
end
