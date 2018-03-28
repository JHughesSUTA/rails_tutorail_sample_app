require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'   # test for error messages
    assert_select 'div.field_with_errors'
    assert_select 'form[action="/signup"]'  # tests that submitted form goes to /signup rather than /users
  end

  test "valid signup information with account activation" do 
    get signup_path
    assert_difference 'User.count', 1 do    # 2nd argument is option, and means what the difference should be (1 difference)
      post users_path, params: { user: { name: "Example User",
                                         email: 'user@example.com',
                                         password: "password",
                                         password_confirmation: "password" } }
    end

    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)     # 'assigns' lets us access instance variables in the corresponding action
    assert_not user.activated?
    # Try to log in before activation.
    log_in_as(user)
    assert_not is_logged_in?
    # Invalid activation token
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    # Valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # Valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!    # arranges to follow the redirect after submission
    assert_template 'users/show'
    assert is_logged_in?

  end
end