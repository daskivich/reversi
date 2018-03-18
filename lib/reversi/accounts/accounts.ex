defmodule Reversi.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Reversi.Repo

  alias Reversi.Accounts.User
  alias Reversi.Play

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  def get_users_with_stats do
    Repo.all(User)
    |> Enum.map(fn(u) -> Map.put(u, :games, Play.games(u.id)) end)
    |> Enum.map(fn(u) -> Map.put(u, :victories, Play.victories(u.id)) end)
    |> Enum.map(fn(u) -> Map.put(u, :defeats, Play.defeats(u.id)) end)
    |> Enum.map(fn(u) -> Map.put(u, :differential, Play.differential(u.id)) end)
    |> Enum.sort(fn(u1, u2) -> compare_users(u1, u2) end)
  end

  def compare_users(u1, u2) do
    points_one = u1.victories - u1.defeats
    points_two = u2.victories - u2.defeats

    cond do
      points_one == points_two && u1.differential == u2.differential -> u1.name < u2.name
      points_one == points_two -> u1.differential > u2.differential
      true -> points_one > points_two
    end
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def get_user(id), do: Repo.get(User, id)

  # a method to get a user by his/her email address, which must be unique
  def get_user_by_email(email) do
    Repo.get_by(User, email: email)
  end

  # method to get a user by email with password authentication from Nat's Notes
  # http://www.ccs.neu.edu/home/ntuck/courses/2018/01/cs4550/notes/17-passwords/notes.html
  def get_and_auth_user(email, password) do
    user = get_user_by_email(email)

    Comeonin.Argon2.check_pass(user, password)
    |> verify_tries(user)

    # case Comeonin.Argon2.check_pass(user, password) do
    #   {:ok, user} -> user |> verify_tries()
    #   _else       -> nil |> verify_tries()
    # end
  end

  def verify_tries(check_result, user) do
    if user.pw_last_try == nil || DateTime.diff(DateTime.utc_now(), user.pw_last_try) > 360 do
      reset_tries(user)

      case check_result do
        {:ok, user} -> user
        _else       -> one_failed_try(user)
      end
    else
      if user.pw_tries > 10 do
        nil
      else
        case check_result do
          {:ok, user} -> reset_tries(user)
          _else       -> increment_tries(user)
        end
      end
    end
  end

  def reset_tries(user) do
    update_user(user, %{pw_tries: 0, pw_last_try: DateTime.utc_now()})
    get_user(user.id)
  end

  def one_failed_try(user) do
    update_user(user, %{pw_tries: 1, pw_last_try: DateTime.utc_now()})
    nil
  end

  def increment_tries(user) do
    update_user(user, %{pw_tries: user.pw_tries + 1, pw_last_try: DateTime.utc_now()})
    nil
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end
end
