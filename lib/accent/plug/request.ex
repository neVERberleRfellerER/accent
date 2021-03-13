defmodule Accent.Plug.Request do
  @moduledoc """
  Transforms the keys of an HTTP request's params to the same or a different
  case.

  You can specify what case to convert keys to by passing in a `:transformer`
  option.

  Accent supports the following transformers out of the box:

  * `Accent.Case.Camel` (e.g. `camelCase`)
  * `Accent.Case.Pascal` (e.g. `PascalCase`)
  * `Accent.Case.Snake` (e.g. `snake_case`)

  If no transformer is provided then `Accent.Case.Snake` will be
  used.

  Please note that this plug will need to be executed after the request has
  been parsed.

  ## Example

  ```
  plug Plug.Parsers, parsers: [:urlencoded, :multipart, :json],
                     pass: ["*/*"],
                     json_decoder: Jason

  plug Accent.Plug.Request, case: Accent.Case.Camel
  ```
  """

  @doc false
  def init(opts \\ []) do
    %{
      case: opts[:case] || Accent.Case.Snake
    }
  end

  @doc false
  def call(conn, opts) do
    case conn.params do
      %Plug.Conn.Unfetched{} ->
        conn

      _ ->
        %{
          conn
          | params: Accent.Case.convert(conn.params, opts[:case]),
            body_params: Accent.Case.convert(conn.body_params, opts[:case]),
            query_params: Accent.Case.convert(conn.query_params, opts[:case])
        }
    end
  end
end
