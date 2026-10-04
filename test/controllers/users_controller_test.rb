require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:superuser)
  end

  test "el superusuario accede al panel de usuarios" do
    get users_path

    assert_response :success
    assert_select "td", "gerente"
    assert_select "a[href=?]", new_user_path
  end

  test "el superusuario crea un usuario con permisos por módulo" do
    assert_difference("User.count", 1) do
      post users_path, params: { user: {
        username: "nuevo.usuario",
        email: "",
        password: "secret123",
        password_confirmation: "secret123",
        superuser: "0",
        permissions: {
          "inventory" => { "can_read" => "1", "can_write" => "1" },
          "hr"        => { "can_read" => "1", "can_write" => "0" },
          "fleet"     => { "can_read" => "0", "can_write" => "0" }
        }
      } }
    end

    user = User.find_by(username: "nuevo.usuario")

    assert_nil user.email, "el correo es opcional"
    assert user.can?("inventory", :write)
    assert user.can?("hr", :read)
    refute user.can?("hr", :write)
    refute user.can?("fleet", :read)
    assert_redirected_to users_path
  end

  test "el superusuario crea otro superusuario" do
    assert_difference("User.count", 1) do
      post users_path, params: { user: {
        username: "root2",
        password: "secret123",
        password_confirmation: "secret123",
        superuser: "1"
      } }
    end

    user = User.find_by(username: "root2")

    assert user.superuser?
    assert user.can?("users", :write)
    assert_equal "Superusuario", user.role_label
  end

  test "actualiza los permisos de un usuario" do
    user = users(:restricted)

    patch user_path(user), params: { user: {
      username: user.username,
      superuser: "0",
      permissions: { "finance" => { "can_read" => "1", "can_write" => "1" } }
    } }

    assert_redirected_to users_path
    assert user.reload.can?("finance", :write)
    refute user.can?("documents", :read)
  end

  test "no permite quitarse el acceso de superusuario a sí mismo" do
    user = users(:superuser)

    patch user_path(user), params: { user: { username: user.username, superuser: "0" } }

    assert_redirected_to edit_user_path(user)
    assert user.reload.superuser?
  end

  test "no permite eliminar el propio usuario" do
    user = users(:superuser)

    assert_no_difference("User.count") do
      delete user_path(user)
    end

    assert_redirected_to users_path
  end

  test "elimina otro usuario" do
    user = users(:restricted)

    assert_difference("User.count", -1) do
      delete user_path(user)
    end

    assert_redirected_to users_path
  end

  test "el formulario de alta muestra la matriz de permisos" do
    get new_user_path

    assert_response :success
    ErpModule.grantable.each do |definition|
      assert_select "input[type=checkbox][name=?]", "user[permissions][#{definition.key}][can_read]"
      assert_select "input[type=checkbox][name=?]", "user[permissions][#{definition.key}][can_write]"
    end
  end

  test "el formulario de edición refleja los permisos actuales" do
    get edit_user_path(users(:restricted))

    assert_response :success
    assert_select "input#user_permission_documents_read[checked]"
    assert_select "input#user_permission_documents_write[checked]", count: 0
    assert_select "input#user_permission_fleet_read[checked]", count: 0
  end

  test "un usuario restringido no accede al panel de usuarios" do
    sign_in_as users(:restricted)

    get users_path

    assert_redirected_to dashboard_root_path
  end

  test "un usuario sin sesión es redirigido al login" do
    delete logout_path
    get users_path

    assert_redirected_to login_path
  end
end
