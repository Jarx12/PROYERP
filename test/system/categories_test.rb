require "application_system_test_case"

# Las categorías se administran desde Configuración; no existe índice ni ficha propia.
class CategoriesTest < ApplicationSystemTestCase
  setup do
    sign_in_as users(:superuser)
    @category = categories(:one)
  end

  test "should create category" do
    visit settings_path

    within "#tab-inventario" do
      click_on "+ Nueva"
    end

    fill_in "category_name", with: "Tornillería"
    fill_in "category_description", with: "Tornillos y tucas"
    click_on "Guardar Categoría"

    assert_text "Categoría creada exitosamente."
    assert_selector "#tab-inventario", text: "Tornillería"
  end

  test "should update Category" do
    visit edit_category_path(@category)

    fill_in "category_name", with: "Materiales eléctrico"
    click_on "Guardar Categoría"

    assert_text "Categoría actualizada exitosamente."
    assert_equal "Materiales eléctrico", @category.reload.name
  end

  test "should destroy Category" do
    visit settings_path

    accept_confirm do
      within "#tab-inventario" do
        first("form[action='#{category_path(@category)}']").find("button").click
      end
    end

    assert_text "Categoría eliminada exitosamente."
    assert_not Category.exists?(@category.id)
  end
end
