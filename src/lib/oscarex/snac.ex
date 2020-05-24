defmodule Oscarex.Snac do
  @families [
    Oscarex.Snac.Oservice,
    Oscarex.Snac.Locate,
    Oscarex.Snac.BuddyList,
    Oscarex.Snac.Icbm,
    Oscarex.Snac.Advert,
    Oscarex.Snac.Invite,
    Oscarex.Snac.Admin,
    Oscarex.Snac.Popup,
    Oscarex.Snac.Bos,
    Oscarex.Snac.UserLookup,
    Oscarex.Snac.Stats,
    Oscarex.Snac.Translate,
    Oscarex.Snac.ChatNavigation,
    Oscarex.Snac.Chat,
    Oscarex.Snac.DirectorySearch,
    Oscarex.Snac.BuddyIcon,
    Oscarex.Snac.ServerSideInfo,
    Oscarex.Snac.Icq,
    Oscarex.Snac.Auth,
    Oscarex.Snac.Alert
  ]

  @doc """
  Get the family label from the given SNAC byte

  ### Example
      iex> Oscarex.Snac.get_family(0x17)
      :auth
  """
  for mod <- @families do
    def get_family(unquote(mod.byte_id())), do: unquote(mod.label())
  end

  def get_family(byte), do: {:unknown, byte}

  @doc """
  Get the handler module for the family by byte header

  ### Example
      iex> Oscarex.Snac.get_handler(0x17)
      Oscarex.Snac.Auth
  """
  for mod <- @families do
    def get_handler(unquote(mod.byte_id())), do: unquote(mod)
  end

  @doc """
  Get the subtype label for the given family and subfamily byte

  ### Example
      iex> Oscarex.Snac.get_subtype(0x17, 0x02)
      :login_request
  """
  for mod <- @families,
      {label, byte} <- mod.messages() do
    def get_subtype(unquote(mod.byte_id()), unquote(byte)), do: unquote(label)
  end

  def get_subtype(_, _), do: :unknown
end
