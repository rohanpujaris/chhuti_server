defmodule ChhutiServer.UserTest do
  use ChhutiServer.ModelCase

  alias ChhutiServer.User

  @valid_attrs %{email: "abc@kiprosh.com", name: "some content", picture: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "email id must be from kiprosh.com domain" do
    assert {:email, "Email id must be from kiprosh domain"} in
      errors_on(%User{}, %{@valid_attrs | email: "abc@abc.com"})
    assert User.changeset(%User{}, %{@valid_attrs | email: "abc@kiprosh.com"}).valid?
  end
end
