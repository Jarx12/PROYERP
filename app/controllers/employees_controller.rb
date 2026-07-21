class EmployeesController < ApplicationController
  before_action :set_employee, only: %i[ show edit update destroy ]

  def index
    @employees = Employee.order(surname: :asc, name: :asc)
  end

  def show
  end

  def new
    @employee = Employee.new
  end

  def edit
  end

  def create
    @employee = Employee.new(employee_params)

    if @employee.save
      redirect_to employees_path, notice: "Empleado creado exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @employee.update(employee_params)
      redirect_to employees_path, notice: "Empleado actualizado correctamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @employee.destroy!
    redirect_to employees_path, notice: "Empleado eliminado.", status: :see_other
  end

  private

  def set_employee
    @employee = Employee.find(params[:id])
  end

  def employee_params
    params.require(:employee).permit(
      :name, :name2, :surname, :surname2, :cedula,
      :direccion, :telefono, :birthday, :hire_date, :salary, :position_id
    )
  end
end