defmodule ExMdBlog.WebServer.RESTHandler do
  @moduledoc """
  A REST Cowboy handler for `ExMdBlog.WebServer` being applied on `ExMdBlog.WebServer.Router`.
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
    params = %{
      body: parse_body!(req),
      qs: parse_qs!(req),
      bindings: req.bindings
    }

    {status, body} = handler.(req, params)
    encoded_body = Jason.encode!(body)

    req =
      if is_map(encoded_body) do
        :cowboy_req.set_resp_body(encoded_body, req)
      else
        req
      end

    req = :cowboy_req.set_resp_headers(reply_headers(), req)

    {:ok, :cowboy_req.reply(status, req), %{}}
  end

  defp reply_error(req, type) when is_binary(type) do
    req = :cowboy_req.set_resp_body(error(type), req)
    req = :cowboy_req.set_resp_headers(reply_headers(), req)

    {:ok, :cowboy_req.reply(404, req), %{}}
  end

  defp method(%{method: "GET"}), do: :get
  defp method(%{method: "POST"}), do: :post
  defp method(%{method: "PUT"}), do: :put
  defp method(%{method: "PATCH"}), do: :patch
  defp method(%{method: "DELETE"}), do: :delete
  defp method(%{method: "OPTIONS"}), do: :options

  defp reply_headers do
    %{"content-type" => "application/json"}
  end

  defp parse_body!(req) do
    with {:has_body, true} <- {:has_body, :cowboy_req.has_body(req)},
         {:ok, raw_body, _req} <- :cowboy_req.read_body(req),
         {:ok, body} <- Jason.decode(raw_body) do
      body
    else
      {:has_body, false} -> %{}
      _ -> raise WithClauseError
    end
  end

  defp parse_qs!(req) do
    req
    |> :cowboy_req.parse_qs()
    |> Enum.reject(&(&1 == true))
    |> Map.new()
  end

  defp error(type) do
    Jason.encode!(%{error: type})
  end
end
