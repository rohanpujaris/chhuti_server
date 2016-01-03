defmodule MyApp.Plug.Auth do
  import Plug.Conn

  def init(_) do

  end

  def call(_, _) do

  end

  defmacro __using__(_) do
    quote do
      import MyApp.Plug.Auth
      # import MyApp.Plug.GetAcessToken
      # plug MyApp.Plug.GetAcessToken
      plug MyApp.Plug.Auth
    end
  end
end