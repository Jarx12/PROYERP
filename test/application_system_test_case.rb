require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 1400 ]

  # Contraseña compartida por los usuarios de test/fixtures/users.yml
  TEST_PASSWORD = "secret123".freeze

  # El ERP exige sesión, por lo que cada prueba debe autenticarse primero.
  def sign_in_as(user, password: TEST_PASSWORD)
    visit login_path
    fill_in "identifier", with: user.username
    fill_in "password", with: password
    click_on "Iniciar Sesión"
    assert_selector ".erp-body", visible: true
  end
end
