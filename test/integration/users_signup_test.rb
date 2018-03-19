require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

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

  test "valid signup information" do 
    get signup_path
    assert_difference 'User.count', 1 do    # 2nd argument is option, and means what the difference should be (1 difference)
      post users_path, params: { user: { name: "Example User",
                                         email: 'user@example.com',
                                         password: "password",
                                         password_confirmation: "password" } }
    end
    follow_redirect!    # arranges to follow the redirect after submission
    assert_template 'users/show'
    assert_not flash.nil?   # tests that the flash message appears
    assert is_logged_in?    # uses the helper in 'test_helper'
  end
end