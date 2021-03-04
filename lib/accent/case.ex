defmodule Accent.Case do
  @doc """
  Converts a string or atom to the same or different case.
  """
  @callback call(String.t() | atom) :: String.t() | atom

  @doc """
  Convert the keys of a map or list based on the provided transformer.

  If the value of a given key is a map then all keys of the embedded map will be converted as well.
  """
  def convert(item, transformer)

  def convert(item, _transformer) when is_struct(item) do
    item
  end

  @spec convert(map, module) :: map
  def convert(map, transformer) when is_map(map) do
    for {k, v} <- map, into: %{} do
      key = transformer.call(k)
      {key, convert(v, transformer)}
    end
  end

  @spec convert(list, module) :: list
  def convert(list, transformer) when is_list(list) do
    for i <- list, into: [] do
      convert(i, transformer)
    end
  end

  def convert(item, _transformer) do
    item
  end
end
