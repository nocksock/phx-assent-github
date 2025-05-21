defmodule AppWeb.GithubAuth do
  use AppWeb, :controller
  alias Assent.Strategy.Github

  @config [
      client_id: System.get_env("GITHUB_CLIENT_ID"),
      client_secret: System.get_env("GITHUB_CLIENT_SECRET"),
      redirect_uri: "http://localhost:4000/auth/github/callback",
      authorization_params: [scope: "read:user,user:email,read:org"]
    ]

  # http://localhost:4000/auth/github
  def request(conn, _) do
    @config
    |> Github.authorize_url()
    |> case do
      {:ok, %{url: url, session_params: session_params}} ->
        # Session params (used for OAuth 2.0 and OIDC strategies) will be
        # retrieved when user returns for the callback phase
        conn = put_session(conn, :session_params, session_params)

        # Redirect end-user to Github to authorize access to their account
        conn
        |> put_resp_header("location", url)
        |> send_resp(302, "")

      {:error, _error} ->
        # Something went wrong generating the request authorization url
        conn 
        |> put_flash(:error, "Failed to authorize")
        |> redirect(to: "/")
    end
  end

  # http://localhost:4000/auth/github/callback
  def callback(conn, _) do
    # End-user will return to the callback URL with params attached to the
    # request. These must be passed on to the strategy. In this example we only
    # expect GET query params, but the provider could also return the user with
    # a POST request where the params is in the POST body.
    %{params: params} = fetch_query_params(conn)

    # The session params (used for OAuth 2.0 and OIDC strategies) stored in the
    # request phase will be used in the callback phase
    session_params = get_session(conn, :session_params)

    conn = delete_session(conn, :session_params)

    @config
    # Session params should be added to the config so the strategy can use them
    |> Keyword.put(:session_params, session_params)
    |> Github.callback(params)
    |> case do
      {:ok, %{user: user, token: token}} ->
      dbg "User: #{inspect(user)}"
        # Authorization succesful
        conn
        |> put_session(:user, user)
        |> put_session(:token, token)
        |> put_resp_header("location", "/")
        |> send_resp(302, "")

      {:error, error} ->
        conn 
        |> put_flash(:error, inspect error)
        |> redirect(to: "/")
    end
  end
end
