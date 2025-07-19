# test/models/post_test.rb
require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "should be valid with a valid status" do
    post = Post.new(status: 'draft', user: users(:one), content: 'Test content')
    assert post.valid?
  end

  test "should be invalid with an invalid status" do
    post = Post.new(status: 'invalid_status', user: users(:one), content: 'Test content')
    assert_not post.valid?
  end
end