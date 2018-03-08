require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test "layout links" do
    get root_path
    assert_template 'static_pages/home'             # verify home page is rendered using correct view
    # below verifies the presence of certain links
    assert_select "a[href=?]", root_path, count: 2  # verifies that there are two such links
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    # the sytax on the line above inserts the value of 'about_path' into the question mark,
    # thereby checking for the html tag: <a href="/about">...</a>
    assert_select "a[href=?]", contact_path
    
    get contact_path
    assert_select "title", full_title("Contact")  #tests for the correct title (chapter 5)

    get signup_path
    assert_select "title", full_title("Sign up")  #tests for the correct title (chapter 5)
  end
end
