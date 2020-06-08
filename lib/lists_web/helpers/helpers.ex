defmodule ListsWeb.Helpers do
  def mapped_errors(errors) do
    errors
    |> Enum.map fn {attr, {message, _}} -> %{attr => message} end
  end
end
