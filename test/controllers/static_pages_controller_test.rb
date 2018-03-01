require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  def setup # automatically run before every test
    @base_title = "Ruby on Rails Tutorial Sample App"
  end

  test "should get home" do
    get static_pages_home_url
    assert_response :success
    # 'assert_select' allows us to check for the presence of a particular HTML tag
    assert_select "title", "Home | #{@base_title}"
    # this line tests for the presence of a <title> tag containing the string "Home | Ruby on Rails..."
  end

  test "should get help" do
    get static_pages_help_url
    assert_response :success
    assert_select "title", "Help | #{@base_title}"
  end

  test "should get about" do
    get static_pages_about_url
    assert_response :success
    assert_select "title", "About | #{@base_title}"
  end
  
end
