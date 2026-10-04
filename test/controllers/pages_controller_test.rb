require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home with the public layout" do
    get root_path

    assert_response :success
    assert_select "body.public-body", 1
    assert_select "header.public-navbar", 1
    assert_select "footer.public-footer", 1
    assert_select "header[style*='background-color: #1a202c']", count: 0
  end

  test "public pages consistently use the public shell" do
    [ about_path, soluciones_path, contactanos_path, proyectos_path ].each do |path|
      get path

      assert_response :success
      assert_select "body.public-body", 1
      assert_select "header.public-navbar", 1
      assert_select "footer.public-footer", 1
    end
  end

  test "services link to the dedicated solutions page" do
    get root_path

    assert_select "#modulos a[href=?]", soluciones_path, text: /Conoce más/
    assert_select "header.public-navbar a[href=?]", soluciones_path, minimum: 1
    assert_select "footer.public-footer a[href=?]", soluciones_path, minimum: 1
  end

  test "ERP pages retain the ERP header layout" do
    sign_in_as users(:superuser)

    get dashboard_root_path

    assert_response :success
    assert_select "body.erp-body", 1
    assert_select "header[style*='background-color: #1a202c']", 1
    assert_select "header.public-navbar", count: 0
  end
end
