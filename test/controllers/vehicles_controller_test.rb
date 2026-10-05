require "test_helper"

class VehiclesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:superuser)
    @vehicle = vehicles(:one)
  end

  test "should get index" do
    get vehicles_url
    assert_response :success
  end

  test "should get new" do
    get new_vehicle_url
    assert_response :success
  end

  test "should create vehicle" do
    assert_difference("Vehicle.count") do
      post vehicles_url, params: { vehicle: {
        brand: "Toyota", model: "Hilux", plate: "DEF-456", status: "available"
      } }
    end

    assert_redirected_to vehicles_path
    assert_equal "Vehículo registrado exitosamente.", flash[:notice]
    assert_equal "DEF-456", Vehicle.order(:id).last.plate
  end

  test "should reject a duplicate plate" do
    other = vehicles(:two)

    assert_no_difference("Vehicle.count") do
      post vehicles_url, params: { vehicle: {
        brand: "Ford", model: "Ranger", plate: other.plate, status: "available"
      } }
    end

    assert_response :unprocessable_entity
  end

  test "should show vehicle" do
    get vehicle_url(@vehicle)
    assert_response :success
  end

  test "should get edit" do
    get edit_vehicle_url(@vehicle)
    assert_response :success
  end

  test "should update vehicle" do
    patch vehicle_url(@vehicle), params: { vehicle: {
      brand: "Toyota", model: "Land Cruiser", plate: @vehicle.plate, status: "in_use"
    } }

    assert_redirected_to vehicles_path
    assert_equal "Vehículo actualizado exitosamente.", flash[:notice]
    assert_equal "Land Cruiser", @vehicle.reload.model
  end

  test "should destroy vehicle" do
    assert_difference("Vehicle.count", -1) do
      delete vehicle_url(@vehicle)
    end

    assert_redirected_to vehicles_path
  end
end
