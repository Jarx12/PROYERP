require "application_system_test_case"

# Los almacenes se administran desde Configuración; no existe índice ni ficha propia.
class WarehousesTest < ApplicationSystemTestCase
  setup do
    sign_in_as users(:superuser)
    @warehouse = warehouses(:one)
  end

  test "should create warehouse" do
    visit settings_path

    within "#tab-inventario" do
      click_on "+ Nuevo", match: :first
    end

    fill_in "warehouse_name", with: "Depósito Sur"
    fill_in "warehouse_code", with: "ALM-010"
    fill_in "warehouse_address", with: "Av. Sur, Valencia"
    click_on "Guardar Almacén"

    assert_text "Almacén creado exitosamente."
    assert_selector "#tab-inventario", text: "Depósito Sur"
  end

  test "should update Warehouse" do
    visit edit_warehouse_path(@warehouse)

    fill_in "warehouse_address", with: "Nueva ubicación"
    click_on "Guardar Almacén"

    assert_text "Almacén actualizado exitosamente."
    assert_equal "Nueva ubicación", @warehouse.reload.address
  end

  test "should destroy Warehouse" do
    visit settings_path

    accept_confirm do
      within "#tab-inventario" do
        first("form[action='#{warehouse_path(@warehouse)}']").find("button").click
      end
    end

    assert_text "Almacén eliminado exitosamente."
    assert_not Warehouse.exists?(@warehouse.id)
  end
end
