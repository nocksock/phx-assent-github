defmodule AppWeb.AuthController do
  use AppWeb, :controller

  def login_page(conn, _params) do
    if get_session(conn, :user) do
      redirect(conn, to: "/dev/dashboard")
    else
      render(conn, :login)
    end
  end

  def logout(conn, _params) do
    conn
    |> delete_session(:user)
    |> delete_session(:token)
    |> put_flash(:info, "You have been logged out")
    |> redirect(to: "/login")
  end
end
