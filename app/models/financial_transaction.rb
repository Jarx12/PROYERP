class FinancialTransaction < ApplicationRecord
  belongs_to :bank_account
  belongs_to :transaction_category, optional: true
  belongs_to :employee, optional: true

  has_one_attached :invoice_file

  # Atributo virtual para recibir la opción del radio button ('yes' o 'no')
  attr_accessor :apply_commission

  validates :description, :amount, :transaction_date, :transaction_type, presence: true
  validates :transaction_type, inclusion: { in: %w[income expense] }

  after_create :update_bank_account_balance_on_create
  after_create :generate_commission_transaction, if: -> { apply_commission == 'yes' && amount.to_f > 0 }
  
  before_destroy :revert_bank_account_balance_on_destroy

  private

  def update_bank_account_balance_on_create
    if transaction_type == 'income'
      bank_account.increment!(:balance, amount)
    else
      bank_account.decrement!(:balance, amount)
    end
  end

  def generate_commission_transaction
    # Calculamos el 0.3% (puedes ajustarlo si necesitas otro porcentaje)
    commission_amount = (amount * 0.003).round(2)
    
    return if commission_amount <= 0

    # Creamos un egreso automático por concepto de comisión
    # Usamos self.class.create! para evitar validaciones cruzadas profundas o loops
    self.class.create!(
      bank_account_id: bank_account_id,
      transaction_type: 'expense',
      amount: commission_amount,
      transaction_date: transaction_date,
      description: "Comisión bancaria automática (0.3%) sobre transacción ##{id}: #{description.truncate(30)}",
      responsible_name: responsible_name,
      employee_id: employee_id
    )
  end

  def revert_bank_account_balance_on_destroy
    if transaction_type == 'income'
      bank_account.decrement!(:balance, amount)
    else
      bank_account.increment!(:balance, amount)
    end
  end
end