class FinancialTransactionsController < ApplicationController
  before_action :set_transaction, only: %i[show destroy]

def index
  @bank_accounts = BankAccount.order(:institution)

  @financial_transactions = FinancialTransaction
    .includes(:bank_account, :transaction_category, :employee)
    .with_attached_invoice_file   
    .with_attached_bank_receipt  
    .order(transaction_date: :desc, id: :desc)

  if params[:bank_account_id].present?
    @financial_transactions = @financial_transactions.where(bank_account_id: params[:bank_account_id])
  end

  @financial_transactions = @financial_transactions.page(params[:page]).per(50)
end

  def show
  end

  def new
    @financial_transaction = FinancialTransaction.new
    @bank_accounts = BankAccount.all
    @employees = Employee.all 
    @transaction_categories = TransactionCategory.all
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


  def bulk_import
    if request.post?
      json_data = params[:json_data]
      bank_account_id = params[:bank_account_id]

      begin
        records = JSON.parse(json_data)
        created_count = 0

        FinancialTransaction.transaction do
          records.each do |item|
            FinancialTransaction.create!(
              bank_account_id: bank_account_id,
              transaction_date: item["transaction_date"],
              description: item["description"],
              beneficiary: item["beneficiary"],
              bank_reference: item["bank_reference"],
              transaction_type: item["transaction_type"],
              amount: item["amount"].to_f.abs
            )
            created_count += 1
          end
        end

        redirect_to financial_transactions_path, notice: "¡Éxito! Se importaron #{created_count} transacciones correctamente."
      rescue JSON::ParserError => e
        flash.now[:alert] = "El formato JSON ingresado no es válido."
        render :bulk_import, status: :unprocessable_entity
      rescue StandardError => e
        flash.now[:alert] = "Error durante la importación: #{e.message}"
        render :bulk_import, status: :unprocessable_entity
      end
    end
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
      :bank_receipt,
      :commission_percentage
    )
  end
end