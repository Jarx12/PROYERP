class BankAccount < ApplicationRecord
  has_many :transactions, dependent: :restrict_with_error
  
  validates :institution, presence: true
  validates :currency, presence: true, inclusion: { in: %w[VES USD] }

  def display_name
    "#{institution} (#{currency}) - #{account_number.present? ? account_number : 'Sin Nro'}"
  end
end