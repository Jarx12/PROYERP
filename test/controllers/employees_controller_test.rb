require "test_helper"

class EmployeesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:superuser)
    @employee = employees(:one)
  end

  test "should get index" do
    get employees_url
    assert_response :success
  end

  test "should get new" do
    get new_employee_url
    assert_response :success
  end

  test "should create employee" do
    assert_difference("Employee.count") do
      post employees_url, params: { employee: {
        birthday: "1995-04-10", cedula: 11223344, direccion: "Av. Test, Caracas",
        hire_date: "2024-02-01", name: "Nuevo", name2: "Empleado",
        salary: 500, surname: "De", surname2: "Prueba", telefono: "0412-0000000"
      } }
    end

    assert_redirected_to employees_path
    assert_equal "Empleado creado exitosamente.", flash[:notice]
    assert_equal 11_223_344, Employee.order(:id).last.cedula
  end

  test "should create employee without position" do
    assert_difference("Employee.count") do
      post employees_url, params: { employee: {
        birthday: "1995-04-10", cedula: 99887766, direccion: "Av. Test, Caracas",
        hire_date: "2024-02-01", name: "Sin", name2: "Cargo",
        salary: 500, surname: "De", surname2: "Prueba", telefono: "0412-0000000"
      } }
    end

    assert_redirected_to employees_path
    assert_nil Employee.order(:id).last.position_id, "el cargo es opcional"
  end

  test "should reject a duplicate cedula" do
    other = employees(:two)

    assert_no_difference("Employee.count") do
      post employees_url, params: { employee: {
        birthday: "1995-04-10", cedula: other.cedula, direccion: "Av. Test",
        hire_date: "2024-02-01", name: "Duplicado", surname: "Cédula", telefono: "0412-0000000"
      } }
    end

    assert_response :unprocessable_entity
  end

  test "should show employee" do
    get employee_url(@employee)
    assert_response :success
  end

  test "should get edit" do
    get edit_employee_url(@employee)
    assert_response :success
  end

  test "should update employee" do
    patch employee_url(@employee), params: { employee: {
      birthday: @employee.birthday, cedula: @employee.cedula, direccion: "Nueva dirección",
      hire_date: @employee.hire_date, name: @employee.name, name2: @employee.name2,
      salary: 750, surname: @employee.surname, surname2: @employee.surname2,
      telefono: @employee.telefono
    } }

    assert_redirected_to employees_path
    assert_equal "Empleado actualizado correctamente.", flash[:notice]
    assert_equal "Nueva dirección", @employee.reload.direccion
  end

  test "should discard employee" do
    assert_no_difference("Employee.count") do
      assert_difference("Employee.kept.count", -1) do
        delete employee_url(@employee)
      end
    end

    assert_redirected_to employees_path
    assert_equal "Empleado desactivado exitosamente.", flash[:notice]
    assert @employee.reload.discarded?, "el empleado se descarta, no se elimina"
  end

  test "should restore a discarded employee" do
    @employee.discard

    patch restore_employee_url(@employee)

    assert_redirected_to discarded_employees_path
    assert @employee.reload.kept?, "el empleado vuelve a estar activo"
  end
end
