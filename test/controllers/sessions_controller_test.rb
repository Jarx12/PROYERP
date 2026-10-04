require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get login_path
    assert_response :success
  end

  test "inicia sesión con el nombre de usuario" do
    post login_path, params: { identifier: users(:manager).username, password: "secret123" }

    assert_redirected_to dashboard_root_path
  end

  test "inicia sesión con el correo electrónico" do
    sign_in_as users(:manager), identifier: "gerente@proyerp.test"

    assert_redirected_to dashboard_root_path
  end

  test "rechaza credenciales inválidas" do
    post login_path, params: { identifier: users(:manager).username, password: "incorrecta" }

    assert_response :unprocessable_entity
  end

  test "should get destroy" do
    sign_in_as users(:manager)
    delete logout_path

    assert_redirected_to login_path
  end
end
