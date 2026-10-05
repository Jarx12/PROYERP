require "application_system_test_case"

class EmployeesTest < ApplicationSystemTestCase
  setup do
    sign_in_as users(:superuser)
    @employee = employees(:one)
  end

  test "visiting the index" do
    visit employees_url

    assert_selector "h1", text: "Personal y Nómina"
  end

  test "should create employee" do
    visit new_employee_url

    fill_in "employee_name", with: "Nuevo"
    fill_in "employee_surname", with: "Empleado"
    fill_in "employee_cedula", with: "11223344"
    fill_in "employee_birthday", with: "1995-04-10"
    fill_in "employee_hire_date", with: "2024-02-01"
    fill_in "employee_salary", with: "500"
    click_on "Guardar Empleado"

    assert_text "Empleado creado exitosamente."
    assert_equal 11_223_344, Employee.order(:id).last.cedula
  end

  test "should update Employee" do
    visit edit_employee_url(@employee)

    fill_in "employee_direccion", with: "Nueva dirección"
    click_on "Guardar Empleado"

    assert_text "Empleado actualizado correctamente."
    assert_equal "Nueva dirección", @employee.reload.direccion
  end

  test "should discard Employee" do
    visit employees_url

    accept_confirm do
      within "tr", text: @employee.cedula.to_s do
        click_on "Eliminar"
      end
    end

    assert_text "Empleado desactivado exitosamente."
    assert @employee.reload.discarded?, "el empleado se descarta, no se elimina"
  end
end
