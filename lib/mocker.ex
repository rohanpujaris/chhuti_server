defmodule ChhutiServer.Mocker do
  defmacro mock_for_test({:__aliases__, _, module_path}, module_attribute \\ nil) do
    module_attribute = module_attribute || get_module_attribute_name(module_path)
    module = if Mix.env == :test do
      mock_module_name(module_path)
    else
      Module.concat module_path
    end
    quote do
      IO.inspect unquote(module_attribute)
      Module.put_attribute __MODULE__, unquote(module_attribute), unquote(module)
    end
  end

  def get_module_attribute_name(module_path) do
    module_path |> List.last |> Atom.to_string |>  Inflex.underscore |> String.to_atom
  end

  def mock_module_name(module) do
    module
      |> List.insert_at(-2, :Mock)
      |> Module.concat
  end
end
