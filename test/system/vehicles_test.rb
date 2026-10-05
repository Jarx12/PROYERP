require "application_system_test_case"

class VehiclesTest < ApplicationSystemTestCase
  setup do
    sign_in_as users(:superuser)
    @vehicle = vehicles(:one)
  end

  test "visiting the index" do
    visit vehicles_url

    assert_selector "h1", text: "Flota Vehicular"
  end

  test "should create vehicle" do
    visit new_vehicle_url

    fill_in "vehicle_plate", with: "DEF-456"
    fill_in "vehicle_brand", with: "Toyota"
    fill_in "vehicle_model", with: "Hilux"
    click_on "Guardar Vehículo"

    assert_text "Vehículo registrado exitosamente."
    assert_equal "DEF-456", Vehicle.order(:id).last.plate
  end

  test "should update vehicle" do
    visit edit_vehicle_url(@vehicle)

    fill_in "vehicle_model", with: "Land Cruiser"
    click_on "Guardar Vehículo"

    assert_text "Vehículo actualizado exitosamente."
    assert_equal "Land Cruiser", @vehicle.reload.model
  end

  test "should destroy vehicle" do
    visit vehicles_url

    accept_confirm do
      within "tr", text: @vehicle.plate do
        click_on "Eliminar"
      end
    end

    assert_text "Vehículo eliminado exitosamente."
    assert_not Vehicle.exists?(@vehicle.id)
  end
end
