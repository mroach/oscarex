defmodule Oscarex.Snac.Base do
  defmacro __using__(opts) do
    quote do
      @label __MODULE__
             |> Module.split()
             |> Enum.at(-1)
             |> Macro.underscore()
             |> String.to_atom()

      @std_msgs [error: 0x01, default: 0xFFFF]
      @client_msgs unquote(Keyword.get(opts, :client_messages, []))
      @server_msgs unquote(Keyword.get(opts, :server_messages, []))
      @bidi_msgs unquote(Keyword.get(opts, :bidi_messages, []))
      @all_messages @std_msgs ++ @client_msgs ++ @server_msgs ++ @bidi_msgs

      @doc """
      Byte identifier for the service itself.
      """
      def byte_id, do: unquote(Keyword.fetch!(opts, :byte_id))

      @doc """
      Keyword list of messages and their byte identifiers.
      """
      def messages, do: @all_messages

      @doc """
      Atom label to distinguish this service
      """
      def label, do: @label
    end
  end
end
