defmodule ElixirSearchExtractorWeb.Plugs.SetCurrentApiUser do
  import Plug.Conn

  def init(options), do: options

  def call(conn, _opts) do
    user = ExOauth2Provider.Plug.current_resource_owner(conn)

    assign(conn, :current_user, user)
  end
end
