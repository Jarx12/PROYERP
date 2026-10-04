require "test_helper"

# Los cargos se administran desde la pantalla de Configuración (no existe
# index ni show propio), por lo que el CRUD redirige a settings_path.
class PositionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:superuser)
    @position = positions(:one)
  end

  test "should get new" do
    get new_position_url
    assert_response :success
  end

  test "should create position" do
    assert_difference("Position.count") do
      post positions_url, params: { position: { description: "Personal administrativo", title: "Asistente" } }
    end

    assert_redirected_to settings_path
    assert_equal "Position was successfully created.", flash[:notice]
    assert_equal "Asistente", Position.order(:id).last.title
  end

  test "should get edit" do
    get edit_position_url(@position)
    assert_response :success
  end

  test "should update position" do
    patch position_url(@position), params: { position: { description: "Nueva descripción", title: @position.title } }

    assert_redirected_to settings_path
    assert_equal "Position was successfully updated.", flash[:notice]
    assert_equal "Nueva descripción", @position.reload.description
  end

  test "should destroy position" do
    employee = employees(:one)
    assert_equal @position, employee.position

    assert_difference("Position.count", -1) do
      delete position_url(@position)
    end

    assert_redirected_to settings_path
    assert_equal "Position was successfully destroyed.", flash[:notice]
    assert_nil employee.reload.position_id, "el empleado queda sin cargo asociado"
  end

  test "should reject a duplicate position title" do
    other = positions(:two)

    assert_no_difference("Position.count") do
      post positions_url, params: { position: { description: "Duplicado", title: other.title } }
    end

    assert_response :unprocessable_content
  end

  test "no existen index ni show propios de cargo" do
    get positions_url
    assert_response :not_found

    get position_url(@position)
    assert_response :not_found
  end
end
