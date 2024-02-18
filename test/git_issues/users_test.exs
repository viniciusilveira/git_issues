defmodule GitIssues.UsersTest do
  use ExUnit.Case, async: true

  alias GitIssues.Users

  describe "get/2" do
    test "with success when the repository exists and the user is valid" do
      assert {:ok, user} = Users.get("elixir-lang")

      assert user == "The Elixir programming language"
    end

    test "with error when the repository does not exist" do
      error =
        """
        {
        "message": "Not Found",
        "documentation_url": "https://docs.github.com/rest/users/users#get-a-user"
        }
        """
        |> Jason.decode!()

      assert {:error, error} == Users.get("elixir-lang-foo")
    end
  end
end
