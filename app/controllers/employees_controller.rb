class EmployeesController < ApplicationController
  before_action :set_employee, only: %i[ show edit update destroy restore]

  def index
    @employees = Employee.kept.includes(:position).order(surname: :asc)
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
      @employee.discard

      respond_to do |format|
        format.html { redirect_to employees_path, notice: "Empleado desactivado exitosamente.", status: :see_other }
        format.json { head :no_content }
      end
    end

  def discarded
    @discarded_employees = Employee.discarded.includes(:position).order(discarded_at: :desc)
    @active_employees_count = Employee.kept.count
  end

  def restore
      if @employee.undiscard
        redirect_to discarded_employees_path, notice: "Empleado #{@employee.name} #{@employee.surname} reactivado exitosamente."
      else
        redirect_to discarded_employees_path, alert: "No se pudo reactivar el empleado."
      end
    end

  def bulk_payroll
    @employees = Employee.all
    @bank_accounts = BankAccount.all
  end

 def process_bulk_payroll
  employee_ids = params[:employee_ids] || []
  exchange_rate = params[:exchange_rate].to_f
  bank_account_id = params[:bank_account_id]
  period_start = params[:period_start_date]
  period_end = params[:period_end_date]
  commissions = params[:commissions] || {}
  bank_references = params[:bank_references] || {}
  bank_receipts = params[:bank_receipts] || {}
  adjustments = params[:adjustments] || {}
  extra_workers = params[:extra_workers] || {}

  # Verificar que hay al menos un empleado (fijo u ocasional)
  if (employee_ids.empty? && extra_workers.empty?) || exchange_rate <= 0 || bank_account_id.blank?
    redirect_to bulk_payroll_employees_path, alert: "Por favor seleccione al menos un empleado, agregue un trabajador ocasional, la cuenta bancaria y una tasa de cambio válida."
    return
  end

  payroll_category = TransactionCategory.find_or_create_by!(name: "Nómina")
  created_count = 0
  validation_errors = []

  start_formatted = Date.parse(period_start).strftime("%d/%m/%Y") rescue period_start
  end_formatted = Date.parse(period_end).strftime("%d/%m/%Y") rescue period_end

  FinancialTransaction.transaction do
    # --- 1. PROCESAR EMPLEADOS FIJOS ---
    Employee.where(id: employee_ids).each do |emp|
      base_salary = emp.salary.to_f
      extra_adj = adjustments[emp.id.to_s].to_f
      total_usd = base_salary + extra_adj

      amount_in_bs = (total_usd * exchange_rate).round(2)
      next if amount_in_bs <= 0

      emp_name = emp.respond_to?(:full_name_complete) ? emp.full_name_complete : "#{emp.name} #{emp.surname}"
      emp_commission = commissions[emp.id.to_s] || "0.3%"
      emp_reference = bank_references[emp.id.to_s]
      emp_receipt = bank_receipts[emp.id.to_s]

      adj_text = extra_adj != 0 ? " (Ajuste extra: #{extra_adj >= 0 ? '+' : ''}$#{'%.2f' % extra_adj})" : ""

      transaction = FinancialTransaction.create!(
        bank_account_id: bank_account_id,
        transaction_category_id: payroll_category.id,
        employee_id: emp.id,
        transaction_type: 'expense',
        amount: amount_in_bs,
        transaction_date: Date.today,
        bank_reference: emp_reference,
        beneficiary: emp_name,
        responsible_name: emp_name,
        description: "Pago de nomina del periodo #{start_formatted} a #{end_formatted} de #{emp_name}#{adj_text}",
        commission_percentage: emp_commission
      )

      transaction.bank_receipt.attach(emp_receipt) if emp_receipt.present?
      created_count += 1
    end

    # --- 2. PROCESAR TRABAJADORES OCASIONALES ---
    extra_workers.each do |uid, worker_data|
      begin
        worker_name = worker_data[:name].presence || worker_data["name"].presence
        worker_cedula = worker_data[:cedula].presence || worker_data["cedula"].presence
        base_salary = (worker_data[:base_salary].presence || worker_data["base_salary"].presence || 0).to_f
        
        if worker_name.blank?
          validation_errors << "Trabajador ocasional #{(uid.to_i + 1)}: Nombre es requerido"
          next
        end

        if base_salary <= 0
          validation_errors << "Trabajador ocasional #{worker_name}: Salario base debe ser mayor a 0"
          next
        end

        extra_adj = (worker_data[:adjustment].presence || worker_data['adjustment'].presence || 0).to_f
        total_usd = base_salary + extra_adj

        amount_in_bs = (total_usd * exchange_rate).round(2)
        if amount_in_bs <= 0
          validation_errors << "Trabajador ocasional #{worker_name}: Monto en Bs. es 0 o negativo"
          next
        end

        emp_commission = worker_data[:commission].presence || worker_data['commission'].presence || "0.3%"
        emp_reference = worker_data[:bank_reference].presence || worker_data['bank_reference'].presence
        emp_receipt = worker_data[:bank_receipt].presence || worker_data['bank_receipt'].presence

        adj_text = extra_adj != 0 ? " (Ajuste extra: #{extra_adj >= 0 ? '+' : ''}$#{'%.2f' % extra_adj})" : ""
        cedula_text = worker_cedula.present? ? " (C.I: #{worker_cedula})" : ""

        # Se registra la transacción omitiendo el employee_id
        transaction = FinancialTransaction.create!(
          bank_account_id: bank_account_id,
          transaction_category_id: payroll_category.id,
          employee_id: nil,
          transaction_type: 'expense',
          amount: amount_in_bs,
          transaction_date: Date.today,
          bank_reference: emp_reference,
          beneficiary: worker_name,
          responsible_name: worker_name,
          description: "Pago ocasional a #{worker_name}#{cedula_text} - Periodo #{start_formatted} a #{end_formatted}#{adj_text}",
          commission_percentage: emp_commission
        )

        transaction.bank_receipt.attach(emp_receipt) if emp_receipt.present?
        created_count += 1

      rescue StandardError => e
        validation_errors << "Trabajador ocasional #{worker_data[:name] || uid}: #{e.message}"
      end
    end
  end

  # Mostrar resultados
  if created_count > 0
    message = "¡Éxito! Se procesó la nómina para #{created_count} trabajador(es)."
    message += " Pero hay errores en algunos trabajadores: #{validation_errors.join('; ')}" if validation_errors.any?
    redirect_to financial_transactions_path, notice: message
  else
    error_message = "No se pudo procesar ningún pago. "
    error_message += validation_errors.join('; ') if validation_errors.any?
    error_message += " Verifique los datos ingresados." if validation_errors.empty?
    redirect_to bulk_payroll_employees_path, alert: error_message
  end

rescue StandardError => e
  Rails.logger.error "Error en process_bulk_payroll: #{e.message}\n#{e.backtrace.join("\n")}"
  
  error_msg = "Error al procesar la nómina: #{e.message}"
  error_msg += " - #{e.record.errors.full_messages.join(', ')}" if e.respond_to?(:record) && e.record.present?
  redirect_to bulk_payroll_employees_path, alert: error_msg
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