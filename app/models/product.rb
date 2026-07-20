class Product < ApplicationRecord
  has_many :stock_movements, dependent: :destroy

  validates :name, :sku, presence: true
  validates :sku, uniqueness: true
  validates :stock_current, :stock_minimum, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end