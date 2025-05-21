defmodule AppWeb.Plugs.SetScope do
  import Plug.Conn
  import Phoenix.Controller

  def init(default), do: default

  def call(conn, _opts) do
    case get_session(conn, :token) do
      nil -> 
        conn
        |> put_flash(:error, "You must log in to access this page.")
        |> redirect(to: "/login")
        |> halt()
        token ->
          conn
          |> assign(:token, token)
          |> assign(:current_scope, 
          get_session(conn, :user)
          |> App.Accounts.Scope.from_session_data())
      end
  end

  def get_current_scope(token) do
    # Logic to get the current scope based on the token
    # This is a placeholder, replace with actual logic
  end
end
