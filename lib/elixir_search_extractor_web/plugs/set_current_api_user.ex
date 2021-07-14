defmodule ElixirSearchExtractorWeb.Plugs.SetCurrentApiUser do
  @behaviour Plug

  import Plug.Conn

  # coveralls-ignore-start
  def init(options), do: options
  # coveralls-ignore-start

  def call(conn, _opts) do
    user = ExOauth2Provider.Plug.current_resource_owner(conn)

    assign(conn, :current_user, user)
  end
end
