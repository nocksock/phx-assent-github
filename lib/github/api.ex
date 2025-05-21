defmodule Github.Api do
  def get(%{"access_token" => access_token}, path) do
    case Req.get!(
           url: "https://api.github.com/#{path}",
           headers: [
             {"authorization", "BEARER #{access_token}"}
           ]
         ) do
      %Req.Response{status: 200, body: body} ->
        body
    end
  end
end
