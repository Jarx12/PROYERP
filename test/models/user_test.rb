require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "el superusuario tiene acceso total a todos los módulos" do
    user = users(:superuser)

    ErpModule.all.each do |definition|
      assert user.can?(definition.key, :read), "debía poder leer #{definition.key}"
      assert user.can?(definition.key, :write), "debía poder escribir en #{definition.key}"
    end
  end

  test "el usuario restringido sólo accede a los módulos asignados" do
    user = users(:restricted)

    assert user.can?("documents", :read)
    refute user.can?("documents", :write)
    refute user.can?("hr", :read)
    refute user.can?("hr", :write)
  end

  test "el panel de inicio es accesible para todos los usuarios" do
    assert users(:restricted).can?("dashboard", :read)
    refute users(:restricted).can?("users", :read)
  end

  test "el correo electrónico es opcional" do
    user = User.new(username: "nuevo_usuario", password: "secret123", password_confirmation: "secret123")

    assert user.valid?, user.errors.full_messages.to_sentence
    assert_nil user.email
  end

  test "el username se normaliza y debe ser único" do
    user = User.new(username: "  NUEVO_USUARIO  ", password: "secret123", password_confirmation: "secret123")

    assert user.save
    assert_equal "nuevo_usuario", user.username

    duplicate = User.new(username: "nuevo_usuario", password: "secret123", password_confirmation: "secret123")
    refute duplicate.valid?
    assert_includes duplicate.errors.attribute_names, :username
  end

  test "se puede autenticar con el username o con el correo" do
    manager = users(:manager)

    assert_equal manager, User.authenticate_by_identifier("gerente", "secret123")
    assert_equal manager, User.authenticate_by_identifier("gerente@proyerp.test", "secret123")
    assert_equal manager, User.authenticate_by_identifier("  GERENTE  ", "secret123")
    assert_nil User.authenticate_by_identifier("gerente", "incorrecta")
    assert_nil User.authenticate_by_identifier("desconocido", "secret123")
  end

  test "sincronizar permisos crea, actualiza y elimina registros" do
    user = users(:restricted)

    user.sync_module_permissions!(
      "hr"        => { "can_read" => "1", "can_write" => "1" },
      "inventory" => { "can_read" => "1", "can_write" => "0" }
    )

    assert user.reload.can?("hr", :write)
    assert user.can?("inventory", :read)
    refute user.can?("inventory", :write)
    refute user.can?("documents", :read), "los permisos ausentes deben eliminarse"
  end

  test "los permisos quedan persistidos por módulo" do
    user = users(:restricted)

    user.sync_module_permissions!("finance" => { "can_read" => "1", "can_write" => "1" })

    assert_equal %w[ finance ], user.reload.permissions.pluck(:module_key)
    assert user.can?("finance", :write)
  end

  test "el resumen de permisos indica los módulos visibles" do
    assert_equal "Acceso total", users(:superuser).permissions_summary
    assert_equal "Documentos", users(:restricted).permissions_summary
    assert_equal "Sin módulos asignados", User.new.permissions_summary
  end
end
