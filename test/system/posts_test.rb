# test/system/posts_test.rb
require "application_system_test_case"

class PostsTest < ApplicationSystemTestCase
  setup do
    @user = users(:one) # This loads the user from test/fixtures/users.yml
    login_as(@user)
  end

  test "creating a new post" do
    visit posts_url
    click_on "Create a New Post"

    fill_in "Content", with: "This is a system test post!"
    select "draft", from: "Status"
    click_on "Create Post"

    assert_text "Post was successfully created."
    assert_text "This is a system test post!"
  end
end