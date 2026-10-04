require "test_helper"

# Los almacenes se administran desde la pantalla de Configuración (no existe
# index ni show propio), por lo que el CRUD redirige a settings_path.
class WarehousesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:superuser)
    @warehouse = warehouses(:one)
  end

  test "should get new" do
    get new_warehouse_url
    assert_response :success
  end

  test "should create warehouse" do
    assert_difference("Warehouse.count") do
      post warehouses_url, params: { warehouse: { address: "Av. Sur, Valencia", code: "ALM-003", name: "Almacén Sur" } }
    end

    assert_redirected_to settings_path
    assert_equal "Almacén creado exitosamente.", flash[:notice]
    assert_equal "Almacén Sur", Warehouse.order(:id).last.name
  end

  test "should get edit" do
    get edit_warehouse_url(@warehouse)
    assert_response :success
  end

  test "should update warehouse" do
    patch warehouse_url(@warehouse), params: { warehouse: { address: "Nueva dirección", code: @warehouse.code, name: @warehouse.name } }

    assert_redirected_to settings_path
    assert_equal "Almacén actualizado exitosamente.", flash[:notice]
    assert_equal "Nueva dirección", @warehouse.reload.address
  end

  test "should destroy warehouse" do
    assert_difference("Warehouse.count", -1) do
      delete warehouse_url(@warehouse)
    end

    assert_redirected_to settings_path
    assert_equal "Almacén eliminado exitosamente.", flash[:notice]
  end

  test "should reject a duplicate warehouse name" do
    other = warehouses(:two)

    assert_no_difference("Warehouse.count") do
      post warehouses_url, params: { warehouse: { address: "Duplicada", code: "ALM-004", name: other.name } }
    end

    assert_response :unprocessable_entity
  end

  test "no existen index ni show propios de almacén" do
    get warehouses_url
    assert_response :not_found

    get warehouse_url(@warehouse)
    assert_response :not_found
  end
end
