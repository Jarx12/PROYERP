class FinancialTransactionsController < ApplicationController
  before_action :set_transaction, only: %i[show destroy]

  def index
    @financial_transactions = FinancialTransaction.includes(:bank_account, :transaction_category, :employee).order(transaction_date: :desc).to_a
  end

  def show
  end

  def new
    @financial_transaction = FinancialTransaction.new(transaction_date: Date.today)
  end

  def create
    @financial_transaction = FinancialTransaction.new(financial_transaction_params)
    
    # Si seleccionaron un empleado pero escribieron un nombre libre, podemos priorizar el nombre del empleado o dejar el texto libre
    if @financial_transaction.employee_id.present?
      emp = Employee.find_by(id: @financial_transaction.employee_id)
      @financial_transaction.responsible_name = "#{emp.name} #{emp.surname}" if emp
    end

    if @financial_transaction.save
      redirect_to financial_transactions_path, notice: "Transacción registrada exitosamente y saldo actualizado."
    else
      render :new, status: :unprocessable_content
    end
  end

  def destroy
    @financial_transaction.destroy
    redirect_to financial_transactions_path, notice: "Transacción eliminada y saldo revertido.", status: :see_other
  end

  private

  def set_transaction
    @financial_transaction = FinancialTransaction.find(params[:id])
  end

  def financial_transaction_params
    params.require(:financial_transaction).permit(
      :bank_account_id,
      :transaction_category_id,
      :employee_id,
      :amount,
      :transaction_type,
      :description,
      :responsible_name,
      :beneficiary,
      :transaction_date,
      :bank_reference,  
      :invoice_file,         
      :bank_receipt
    )
  end
end