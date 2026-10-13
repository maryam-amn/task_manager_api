require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "Should be able to create a user" do
    user = User.new(username: "toto", email: "user@example.com", password: "password", password_confirmation: "password")
    assert user.valid?
  end

  test "Shouldn't be able to create a user without a password" do
    user = User.new(username: "toto", email: "user@example.com")
    assert_not user.valid?
  end

  test "Shouldn't be able to create a user when the password is less than 6 characters" do
    user = User.new(username: "toto", email: "user@example.com",  password: "1234", password_confirmation: "1234")
    assert_not user.valid?
  end

  test "Shouldn't be able to create a user when the email is already taken" do
    user = User.new(username: "toto", email: "admin@example.com", password: "password", password_confirmation: "password")
    assert_not user.valid?
  end

  test "Shouldn't be able to create a user without a username" do
    user = User.new(email: "user@example.com", password: "password", password_confirmation: "password")
    assert_not user.valid?
  end

  test "Shouldn't be able to create a user when the username is too short " do
    user = User.new(username: "te", email: "user@example.com", password: "password", password_confirmation: "password")
    assert_not user.valid?
  end

  test "Shouldn't be able to create a user with the same username as another one" do
    user = User.new(username: "admin_user", email: "user_test@example.com", password: "password", password_confirmation: "password")
    assert_not user.valid?
  end
end
