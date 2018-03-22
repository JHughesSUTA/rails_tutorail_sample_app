require 'test_helper'

class SessionsHelperTest < ActionView::TestCase
  # 1. Define a user variable using the fixtures.
  def setup
    @user = users(:michael)
    # 2. Call the remember method to remember the given user.
    remember(@user)
  end

  # 3. Verify that current_user is equal to the given user.
  test "current_user returns right user when session is nil" do
    assert_equal @user, current_user
    assert is_logged_in?
  end

  # check that the current user is nil if the user’s remember digest doesn’t correspond correctly to the remember token
  # (tests the authenticated? expression in the nested if statement)
  test "current_user returns nil when remember digest is wrong" do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end
end