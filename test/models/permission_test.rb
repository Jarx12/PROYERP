require "test_helper"

class PermissionTest < ActiveSupport::TestCase
  test "el módulo debe pertenecer al catálogo del ERP" do
    permission = Permission.new(user: users(:manager), module_key: "modulo_inexistente")

    refute permission.valid?
    assert_includes permission.errors.attribute_names, :module_key
  end

  test "no se repiten módulos para un mismo usuario" do
    duplicate = Permission.new(user: users(:manager), module_key: "hr")

    refute duplicate.valid?
    assert_includes duplicate.errors.attribute_names, :module_key
  end

  test "otro usuario puede tener el mismo módulo" do
    permission = Permission.new(user: users(:restricted), module_key: "hr")

    assert permission.valid?, permission.errors.full_messages.to_sentence
  end

  test "escribir implica leer" do
    permission = Permission.create!(user: users(:manager), module_key: "inventory", can_write: true)

    assert permission.can_write?
    assert permission.can_read?
  end

  test "expone la etiqueta del módulo" do
    assert_equal "Finanzas", permissions(:manager_finance).module_label
  end
end
