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
      post employees_url, params: { employee: { birthday: @employee.birthday, cedula: @employee.cedula, direccion: @employee.direccion, hire_date: @employee.hire_date, name: @employee.name, name2: @employee.name2, salary: @employee.salary, surname: @employee.surname, surname2: @employee.surname2, telefono: @employee.telefono } }
    end

    assert_redirected_to employee_url(Employee.last)
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
    patch employee_url(@employee), params: { employee: { birthday: @employee.birthday, cedula: @employee.cedula, direccion: @employee.direccion, hire_date: @employee.hire_date, name: @employee.name, name2: @employee.name2, salary: @employee.salary, surname: @employee.surname, surname2: @employee.surname2, telefono: @employee.telefono } }
    assert_redirected_to employee_url(@employee)
  end

  test "should destroy employee" do
    assert_difference("Employee.count", -1) do
      delete employee_url(@employee)
    end

    assert_redirected_to employees_url
  end
end
