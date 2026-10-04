class FinancialTransaction < ApplicationRecord
  belongs_to :bank_account
  belongs_to :transaction_category, optional: true
  belongs_to :employee, optional: true

  has_one_attached :invoice_file
  has_one_attached :bank_receipt  # Comprobante / Voucher de transferencia bancaria

  attr_accessor :commission_percentage

  validates :description, :amount, :transaction_date, :transaction_type, presence: true
  validates :transaction_type, inclusion: { in: %w[income expense] }
  validates :bank_reference, presence: true, allow_blank: true
  after_create :update_bank_account_balance_on_create
  after_create :generate_commission_transaction, if: -> { commission_percentage.to_f > 0 && amount.to_f > 0 }

  before_destroy :revert_bank_account_balance_on_destroy


  def parsed_commission_percentage
      return 0.0 if commission_percentage.blank?

      cleaned_value = commission_percentage.to_s.gsub("%", "").tr(",", ".").strip
      cleaned_value.to_f
    end

  private

  def update_bank_account_balance_on_create
    if transaction_type == "income"
      bank_account.increment!(:balance, amount)
    else
      bank_account.decrement!(:balance, amount)
    end
  end

def generate_commission_transaction
    percent = parsed_commission_percentage
    rate = percent / 100.0

    calculated_commission = (amount.to_f * rate).round(2)

    # Aplica el mínimo legal/bancario de 14.00 Bs.
    commission_amount = [ calculated_commission, 14.0 ].max

    return if commission_amount <= 0

    commission_category = TransactionCategory.find_or_create_by!(name: "Comisiones")
    ref_text = bank_reference.presence ? "Ref. #{bank_reference}" : "Transacción ##{id}"

    self.class.create!(
      bank_account_id: bank_account_id,
      transaction_category_id: commission_category.id,
      transaction_type: "expense",
      amount: commission_amount,
      transaction_date: transaction_date,
      description: "Comisión bancaria (#{percent}%) sobre #{ref_text}: #{description.truncate(30)}",
      responsible_name: responsible_name,
      employee_id: employee_id
    )
  end

  def revert_bank_account_balance_on_destroy
    if transaction_type == "income"
      bank_account.decrement!(:balance, amount)
    else
      bank_account.increment!(:balance, amount)
    end
  end
end
