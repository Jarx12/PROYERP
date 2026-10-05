require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_firefox, screen_size: [ 1400, 1400 ]

  # Contraseña compartida por los usuarios de test/fixtures/users.yml
  TEST_PASSWORD = "secret123".freeze

  # Las pestañas de Configuración se activan por JavaScript y sólo una queda
  # visible a la vez (por defecto "Inventario"), por lo que hay que abrir la
  # pestaña deseada antes de interactuar con su contenido.
  def open_settings_tab(tab_id)
    find("button[data-tab-target='#{tab_id}']").click
    assert_selector "##{tab_id}.is-active"
  end

  # El ERP exige sesión, por lo que cada prueba debe autenticarse primero.
  def sign_in_as(user, password: TEST_PASSWORD)
    visit login_path
    fill_in "identifier", with: user.username
    fill_in "password", with: password
    click_on "Iniciar Sesión"
    assert_selector ".erp-body", visible: true
  end
end
