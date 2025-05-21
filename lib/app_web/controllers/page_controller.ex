defmodule AppWeb.PageController do
  use AppWeb, :controller

  def home(conn, _params) do
    token = get_session(conn, :token)

    conn
    |> assign(:token, token)
    |> assign(:user, Github.Api.get(token, "user"))
    |> render(:home)
  end
end
