defmodule AuthBlog.WebServer.RESTHandler do
  @moduledoc """
  A REST handler for `AuthBlog.WebServer`..
  """

  @behaviour :cowboy_rest

  @impl :cowboy_rest
  def init(req, method_handlers) do
    method = parse_req_method(req)

    case Keyword.fetch(method_handlers, method) do
      {:ok, handler} ->
        req = :cowboy_req.reply(200, headers(), body(req, handler), req)

        {:ok, req, %{}}
      :error ->
        req = :cowboy_req.reply(404, headers(), "", req)

        {:ok, req, %{}}
    end
  end

  defp parse_req_method(%{method: "GET"}), do: :get
  defp parse_req_method(%{method: "POST"}), do: :post
  defp parse_req_method(%{method: "PUT"}), do: :put
  defp parse_req_method(%{method: "PATCH"}), do: :patch
  defp parse_req_method(%{method: "OPTIONS"}), do: :options

  defp headers do
    %{
      "content-type" => "application/json"
    }
  end

  defp body(req, handler) do
    req
    |> handler.("params")
    |> Jason.encode!()
  end
end
