defmodule OscarexTest do
  use ExUnit.Case
  doctest Oscarex

  defp hex_to_bin(message) when is_binary(message) do
    message |> String.split(~r/\s+/, trim: true) |> hex_to_bin()
  end

  defp hex_to_bin(hex_bytes) when is_list(hex_bytes) do
    hex_bytes
    |> Enum.map(&String.upcase/1)
    |> Enum.map(&Base.decode16!/1)
    |> :binary.list_to_bin()
  end

  test "parses an AIM auth request" do
    message = ~S"""
      2a 02 78 25 00 14
      00 17
      00 06
      00 00
      00 00 00 00
      00 01
      00 06
      6d 72 6f 61 63 68
    """

    assert %{
             channel: 2,
             data_length: 20,
             sequence_number: 30757,
             raw_data: _,
             data: %{
               family: :auth,
               flags: 0,
               request_id: 0,
               subtype: :auth_request,
               data: [
                 screen_name: "mroach"
               ]
             }
           } = Oscarex.parse_message(hex_to_bin(message))
  end

  test "parses an AIM auth request response" do
    message = ~S"""
      2a 02 00 02 00 16
      00 17
      00 07
      00 00 00 00
      00 00 00 0a
      36 35 32 31 34 35 38 36 36 34
    """

    assert %{
             channel: 2,
             data_length: 22,
             raw_data: _,
             sequence_number: 2,
             data: %{
               family: :auth,
               subtype: :auth_response,
               request_id: 0,
               flags: 0,
               raw_data: _,
               data: %{auth_key: "6521458664"}
             }
           } = Oscarex.parse_message(hex_to_bin(message))
  end

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
             data: %{
               family: :auth,
               flags: 0,
               request_id: 0,
               subtype: :login_request,
               data: [
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
           } = Oscarex.parse_message(hex_to_bin(message))
  end

  test "parses AIM login reply" do
    message = ~S"""
      2a 02 00 03 00 e8 00 17  00 03 00 00 00 00 00 00
      00 01 00 06 6d 72 6f 61  63 68 00 05 00 13 69 77
      61 72 67 2e 64 64 6e 73  2e 6e 65 74 3a 35 31 39
      31 00 06 00 86 80 5c 6b  6a c9 34 04 c1 92 4a 49
      85 0d 9e f4 23 26 89 f7  14 c8 7e 8d cc dc f0 a3
      5b 81 18 80 72 2b 3f b6  08 40 d3 db 30 f4 f1 d6
      79 26 d2 ef 82 5f f3 94  6b 95 10 c3 01 cd 9d 8c
      d8 8f a8 3f 79 c9 d6 59  cd e6 eb e2 51 ac c6 1e
      d6 a7 14 a5 09 00 21 fa  8d 83 15 dc 1a 7a b4 3a
      a1 46 03 a0 4c b1 5c af  4f 79 21 9a 72 10 42 bd
      cd f0 ec 58 b9 f7 82 d7  6e ad b1 f5 b3 f9 3e 53
      31 b1 41 0a a9 6d 72 6f  61 63 68 00 11 00 12 69
      77 61 72 67 40 63 2e 6d  72 6f 61 63 68 2e 63 6f
      6d 00 54 00 19 68 74 74  70 3a 2f 2f 77 77 77 2e
      69 77 61 72 67 2e 64 64  6e 73 2e 6e 65 74
    """

    assert %{
             channel: 2,
             data_length: 232,
             raw_data: _,
             sequence_number: 3,
             data: %{
               family: :auth,
               subtype: :login_response,
               flags: 0,
               raw_data: _,
               request_id: 0,
               data: [
                 screen_name: "mroach",
                 reconnect_address: "iwarg.ddns.net:5191",
                 auth_cookie: _,
                 user_email: "iwarg@c.mroach.com",
                 change_password_url: "http://www.iwarg.ddns.net"
               ]
             }
           } = Oscarex.parse_message(hex_to_bin(message))
  end

  test "parse AIM login reply" do
    message = "2a 04 4c d7 00 00"

    assert %{
             channel: 4,
             data_length: 0,
             raw_data: "",
             sequence_number: 19671,
             data: ""
           } = Oscarex.parse_message(hex_to_bin(message))
  end

  test "parse AIM thing" do
    message = "2a 01 00 01 00 04 00 00  00 01"

    assert %{
             channel: 1,
             data: [],
             data_length: 4,
             raw_data: <<0x00, 0x00, 0x00, 0x01>>,
             sequence_number: 1
           } = Oscarex.parse_message(hex_to_bin(message))
  end

  test "parse AIM sending auth cookie" do
    message = ~S"""
      2a 01 16 54 00 8e 00 00  00 01 00 06 00 86 80 5c
      6b 6a c9 34 04 c1 92 4a  49 85 0d 9e f4 23 26 89
      f7 14 c8 7e 8d cc dc f0  a3 5b 81 18 80 72 2b 3f
      b6 08 40 d3 db 30 f4 f1  d6 79 26 d2 ef 82 5f f3
      94 6b 95 10 c3 01 cd 9d  8c d8 8f a8 3f 79 c9 d6
      59 cd e6 eb e2 51 ac c6  1e d6 a7 14 a5 09 00 21
      fa 8d 83 15 dc 1a 7a b4  3a a1 46 03 a0 4c b1 5c
      af 4f 79 21 9a 72 10 42  bd cd f0 ec 58 b9 f7 82
      d7 6e ad b1 f5 b3 f9 3e  53 31 b1 41 0a a9 6d 72
      6f 61 63 68
    """

    assert %{
             channel: 1,
             data_length: 142,
             raw_data: _,
             sequence_number: 5716,
             data: [
               auth_cookie: _
             ]
           } = Oscarex.parse_message(hex_to_bin(message))
  end

  test "parse AIM server capabilities response" do
    message = ~S"""
    2a 02 00 02 00 2c 00 01  00 03 00 00 00 00 00 00
    00 01 00 02 00 03 00 04  00 06 00 07 00 08 00 09
    00 10 00 18 00 0a 00 0b  00 13 00 15 00 22 00 25
    00 0f
    """

    assert %{
             channel: 2,
             data_length: 44,
             sequence_number: 2,
             raw_data: _,
             data: %{
               flags: 0,
               request_id: 0,
               raw_data: _,
               data: [
                 :oservice,
                 :locate,
                 :buddy_list,
                 :icbm,
                 :invite,
                 :admin,
                 :popup,
                 :bos,
                 :buddy_icon,
                 :alert,
                 :user_lookup,
                 :stats,
                 :server_side_info,
                 :icq,
                 {:unknown, 34},
                 {:unknown, 37},
                 :directory_search
               ]
             }
           } = Oscarex.parse_message(hex_to_bin(message))
  end

  test "parse client request for service versions" do
    message = ~S"""
      2a 02 16 55 00 32 00 01  00 17 00 00 00 00 00 17
      00 01 00 03 00 13 00 01  00 02 00 01 00 03 00 01
      00 04 00 01 00 06 00 01  00 08 00 01 00 09 00 01
      00 0a 00 01 00 0b 00 01
    """

    assert %{
             channel: 2,
             data_length: 50,
             sequence_number: 5717,
             raw_data: _,
             data: %{
               family: :oservice,
               subtype: :request_service_versions,
               request_id: 23,
               flags: 0,
               raw_data: _,
               data: [
                 oservice: 3,
                 server_side_info: 1,
                 locate: 1,
                 buddy_list: 1,
                 icbm: 1,
                 invite: 1,
                 popup: 1,
                 bos: 1,
                 user_lookup: 1,
                 stats: 1
               ]
             }
           } = Oscarex.parse_message(hex_to_bin(message))
  end

  test "parse MOTD" do
    message = ~S"""
      2a 02 00 04 00 18 00 01  00 13 00 00 00 00 00 00
      00 05 00 02 00 02 00 1e  00 03 00 02 04 b0
    """

    assert %{
             channel: 2,
             sequence_number: 4,
             data_length: 24,
             raw_data: 1,
             data: %{
               family: :oservice,
               subtype: :motd,
               request_id: 0,
               flags: 0,
               data: %{
                 type: :news
               }
             }
           } == Oscarex.parse_message(hex_to_bin(message))
  end

  test "parse some other thing" do
    message = ~S"""
      2A 02 38 BE 03 3B 00 01  00 07 00 00 00 00 00 06
      00 05 00 01 00 00 00 50  00 00 09 C4 00 00 07 D0
      00 00 05 DC 00 00 03 20  00 00 0D 69 00 00 17 70
      00 00 00 00 00 00 02 00  00 00 50 00 00 0B B8 00
      00 07 D0 00 00 05 DC 00  00 03 E8 00 00 17 70 00
      00 17 70 00 00 F9 0B 00  00 03 00 00 00 14 00 00
      13 EC 00 00 13 88 00 00  0F A0 00 00 0B B8 00 00
      11 47 00 00 17 70 00 00  5C D8 00 00 04 00 00 00
      14 00 00 15 7C 00 00 14  B4 00 00 10 68 00 00 0B
      B8 00 00 17 70 00 00 1F  40 00 00 F9 0B 00 00 05
      00 00 00 0A 00 00 15 7C  00 00 14 B4 00 00 10 68
      00 00 0B B8 00 00 17 70  00 00 1F 40 00 00 F9 0B
      00 00 01 00 91 00 01 00  01 00 01 00 02 00 01 00
      03 00 01 00 04 00 01 00  05 00 01 00 06 00 01 00
      07 00 01 00 08 00 01 00  09 00 01 00 0A 00 01 00
      0B 00 01 00 0C 00 01 00  0D 00 01 00 0E 00 01 00
      0F 00 01 00 10 00 01 00  11 00 01 00 12 00 01 00
      13 00 01 00 14 00 01 00  15 00 01 00 16 00 01 00
      17 00 01 00 18 00 01 00  19 00 01 00 1A 00 01 00
      1B 00 01 00 1C 00 01 00  1D 00 01 00 1E 00 01 00
      1F 00 01 00 20 00 01 00  21 00 02 00 01 00 02 00
      02 00 02 00 03 00 02 00  04 00 02 00 06 00 02 00
      07 00 02 00 08 00 02 00  0A 00 02 00 0C 00 02 00
      0D 00 02 00 0E 00 02 00  0F 00 02 00 10 00 02 00
      11 00 02 00 12 00 02 00  13 00 02 00 14 00 02 00
      15 00 03 00 01 00 03 00  02 00 03 00 03 00 03 00
      06 00 03 00 07 00 03 00  08 00 03 00 09 00 03 00
      0A 00 03 00 0B 00 03 00  0C 00 04 00 01 00 04 00
      02 00 04 00 03 00 04 00  04 00 04 00 05 00 04 00
      07 00 04 00 08 00 04 00  09 00 04 00 0A 00 04 00
      0B 00 04 00 0C 00 04 00  0D 00 04 00 0E 00 04 00
      0F 00 04 00 10 00 04 00  11 00 04 00 12 00 04 00
      13 00 04 00 14 00 06 00  01 00 06 00 02 00 06 00
      03 00 08 00 01 00 08 00  02 00 09 00 01 00 09 00
      02 00 09 00 03 00 09 00  04 00 09 00 09 00 09 00
      0A 00 09 00 0B 00 0A 00  01 00 0A 00 02 00 0A 00
      03 00 0B 00 01 00 0B 00  02 00 0B 00 03 00 0B 00
      04 00 0C 00 01 00 0C 00  02 00 0C 00 03 00 13 00
      01 00 13 00 02 00 13 00  03 00 13 00 04 00 13 00
      05 00 13 00 06 00 13 00  07 00 13 00 08 00 13 00
      09 00 13 00 0A 00 13 00  0B 00 13 00 0C 00 13 00
      0D 00 13 00 0E 00 13 00  0F 00 13 00 10 00 13 00
      11 00 13 00 12 00 13 00  13 00 13 00 14 00 13 00
      15 00 13 00 16 00 13 00  17 00 13 00 18 00 13 00
      19 00 13 00 1A 00 13 00  1B 00 13 00 1C 00 13 00
      1D 00 13 00 1E 00 13 00  1F 00 13 00 20 00 13 00
      21 00 13 00 22 00 13 00  23 00 13 00 24 00 13 00
      25 00 13 00 26 00 13 00  27 00 13 00 28 00 15 00
      01 00 15 00 02 00 15 00  03 00 02 00 06 00 03 00
      04 00 03 00 05 00 09 00  05 00 09 00 06 00 09 00
      07 00 09 00 08 00 03 00  02 00 02 00 05 00 04 00
      06 00 04 00 02 00 02 00  09 00 02 00 0B 00 05 00
      00
    """

    assert %{
             channel: 2,
             sequence_number: 5,
             data_length: 827,
             data: %{
               family: :oservice,
               subtype: :rate_info,
               request_id: 6,
               data: %{}
             }
           } == Oscarex.parse_message(hex_to_bin(message))
  end
end
