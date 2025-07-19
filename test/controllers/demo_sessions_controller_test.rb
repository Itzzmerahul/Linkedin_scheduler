require "test_helper"

class DemoSessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get demo_sessions_create_url
    assert_response :success
  end
end
