defmodule AuthBlog.WebServer.RESTHandler do
  @moduledoc """
  A REST Cowboy handler for `AuthBlog.WebServer` being applied on `AuthBlog.WebServer.Router`.
  """

  @behaviour :cowboy_rest

  @impl :cowboy_rest
  def init(req, method_handlers) when is_list(method_handlers) do
    case Keyword.fetch(method_handlers, method(req)) do
      {:ok, handler} -> reply_handle(req, handler)
      :error -> reply_error(req, "invalid_route")
    end
  end

  def init(req, nil) do
    reply_error(req, "invalid_route")
  end

  defp reply_handle(req, handler) do
    {status, body} = handler.(req, "params")
    encoded_body = Jason.encode!(body)

    {:ok, :cowboy_req.reply(status, headers(), encoded_body, req), %{}}
  end

  defp reply_error(req, type) when is_bitstring(type) do
    {:ok, :cowboy_req.reply(404, headers(), error(type), req), %{}}
  end

  defp method(%{method: "GET"}), do: :get
  defp method(%{method: "POST"}), do: :post
  defp method(%{method: "PUT"}), do: :put
  defp method(%{method: "PATCH"}), do: :patch
  defp method(%{method: "OPTIONS"}), do: :options

  defp headers do
    %{"content-type" => "application/json"}
  end

  defp error(type) do
    Jason.encode!(%{error: type})
  end
end
