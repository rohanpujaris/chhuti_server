defmodule ChhutiServer.User do
  use ChhutiServer.Web, :model

  schema "users" do
    field :name, :string
    field :email, :string
    field :picture, :string

    timestamps
  end

  @required_fields ~w(name email picture)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """

  # TODO: Move kiprosh.com to constants
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_format :email, ~r/.+@kiprosh.com/, message: "Email id must be from kiprosh domain"
  end
end
