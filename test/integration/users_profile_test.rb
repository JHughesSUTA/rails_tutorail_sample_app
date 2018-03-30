require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper     # so we can use 'full_title' helper

  def setup
    @user = users(:michael)
  end

  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'   # checks for an img tag with class gravatar inside a top-level heading tag (h1)
    assert_match @user.microposts.count.to_s, response.body # response.body contains full html source of the page
    assert_select 'div.pagination', count: 1
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end
end