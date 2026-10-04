require "test_helper"

class SettingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:superuser)
  end

  test "should get index" do
    get settings_path
    assert_response :success
  end
end
