class TransactionCategory < ApplicationRecord
  has_many :transactions, dependent: :nullify
  validates :name, presence: true, uniqueness: true
end