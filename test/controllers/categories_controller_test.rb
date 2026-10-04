require "test_helper"

# Las categorías se administran desde la pantalla de Configuración (no existe
# index ni show propio), por lo que el CRUD redirige a settings_path.
class CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:superuser)
    @category = categories(:one)
  end

  test "should get new" do
    get new_category_url
    assert_response :success
  end

  test "should create category" do
    assert_difference("Category.count") do
      post categories_url, params: { category: { description: "Pinturas y barnices", name: "Pinturas" } }
    end

    assert_redirected_to settings_path
    assert_equal "Categoría creada exitosamente.", flash[:notice]
    assert_equal "Pinturas", Category.order(:id).last.name
  end

  test "should get edit" do
    get edit_category_url(@category)
    assert_response :success
  end

  test "should update category" do
    patch category_url(@category), params: { category: { description: "Descripción actualizada", name: @category.name } }

    assert_redirected_to settings_path
    assert_equal "Categoría actualizada exitosamente.", flash[:notice]
    assert_equal "Descripción actualizada", @category.reload.description
  end

  test "should destroy category" do
    assert_difference("Category.count", -1) do
      delete category_url(@category)
    end

    assert_redirected_to settings_path
    assert_equal "Categoría eliminada exitosamente.", flash[:notice]
  end

  test "should reject a duplicate category name" do
    other = categories(:two)

    assert_no_difference("Category.count") do
      post categories_url, params: { category: { description: "Duplicada", name: other.name } }
    end

    assert_response :unprocessable_entity
  end

  test "no existen index ni show propios de categoría" do
    get categories_url
    assert_response :not_found

    get category_url(@category)
    assert_response :not_found
  end
end
