class Product < ApplicationRecord
  belongs_to :category, optional: true
  belongs_to :warehouse, optional: true
  has_many :stock_movements, dependent: :destroy

  validates :name, :sku, presence: true
  validates :sku, uniqueness: true
  validates :stock_current, :stock_minimum, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :price_cost, :price_sale, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :weight, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end