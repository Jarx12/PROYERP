require "test_helper"

# Verifica que los módulos sin permiso no se muestren ni sean accesibles.
class AuthorizationTest < ActionDispatch::IntegrationTest
  test "el menú sólo muestra los módulos permitidos" do
    sign_in_as users(:restricted) # sólo lectura sobre Documentos

    get dashboard_root_path

    assert_response :success
    assert_select "a[href=?]", documents_path
    assert_select "a[href=?]", employees_path, count: 0
    assert_select "a[href=?]", financial_transactions_path, count: 0
    assert_select "a[href=?]", users_path, count: 0
  end

  test "el dashboard sólo muestra las tarjetas permitidas" do
    sign_in_as users(:restricted)

    get dashboard_root_path

    assert_select "div.dashboard-card", count: 1
    assert_select "a[href=?]", documents_path
  end

  test "un módulo sin acceso no se puede consultar" do
    sign_in_as users(:restricted)

    get employees_path

    assert_redirected_to dashboard_root_path
  end

  test "un módulo sólo de lectura no permite escribir" do
    sign_in_as users(:restricted)

    get new_document_path
    assert_redirected_to dashboard_root_path

    assert_no_difference("Document.count") do
      post documents_path, params: { document: { title: "No permitido", category: 1, status: 1 } }
    end
  end

  test "las acciones de escritura se ocultan si no hay permiso" do
    sign_in_as users(:restricted) # Documentos sólo lectura

    get documents_path

    assert_response :success
    assert_select "a[href=?]", new_document_path, count: 0

    sign_in_as users(:manager) # RRHH con escritura

    get employees_path

    assert_response :success
    assert_select "a[href=?]", new_employee_path
  end

  test "un permiso de escritura habilita el módulo" do
    sign_in_as users(:manager) # RRHH con escritura y Finanzas sólo lectura

    get new_employee_path
    assert_response :success

    get new_financial_transaction_path
    assert_redirected_to dashboard_root_path

    get financial_transactions_path
    assert_response :success
  end

  test "el superusuario accede a todos los módulos" do
    sign_in_as users(:superuser)

    get employees_path
    assert_response :success

    get users_path
    assert_response :success
  end

  test "sin sesión no se accede al ERP" do
    get products_path

    assert_redirected_to login_path
  end
end
