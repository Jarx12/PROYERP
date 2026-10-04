require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:superuser)
  end

  test "should get index" do
    get dashboard_root_path
    assert_response :success
  end
end
