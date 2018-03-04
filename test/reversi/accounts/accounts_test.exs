defmodule Reversi.AccountsTest do
  use Reversi.DataCase

  alias Reversi.Accounts

  describe "users" do
    alias Reversi.Accounts.User

    @valid_attrs %{color_primary: "some color_primary", color_secondary: "some color_secondary", email: "some email", icon_primary: "some icon_primary", icon_secondary: "some icon_secondary", name: "some name"}
    @update_attrs %{color_primary: "some updated color_primary", color_secondary: "some updated color_secondary", email: "some updated email", icon_primary: "some updated icon_primary", icon_secondary: "some updated icon_secondary", name: "some updated name"}
    @invalid_attrs %{color_primary: nil, color_secondary: nil, email: nil, icon_primary: nil, icon_secondary: nil, name: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.color_primary == "some color_primary"
      assert user.color_secondary == "some color_secondary"
      assert user.email == "some email"
      assert user.icon_primary == "some icon_primary"
      assert user.icon_secondary == "some icon_secondary"
      assert user.name == "some name"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.color_primary == "some updated color_primary"
      assert user.color_secondary == "some updated color_secondary"
      assert user.email == "some updated email"
      assert user.icon_primary == "some updated icon_primary"
      assert user.icon_secondary == "some updated icon_secondary"
      assert user.name == "some updated name"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
