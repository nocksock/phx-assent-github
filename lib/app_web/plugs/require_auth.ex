defmodule AppWeb.Plugs.RequireAuth do
  import Plug.Conn
  import Phoenix.Controller

  def init(default), do: default

  def call(conn, _opts) do
    if get_session(conn, :user) do
      conn
    else
      conn
      |> redirect(to: "/login")
      |> halt()
    end
  end
end
