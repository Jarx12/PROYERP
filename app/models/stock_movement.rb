class StockMovement < ApplicationRecord
  belongs_to :product

  # Sintaxis correcta para Rails 7.1 / 8+
  enum :movement_type, { input: 0, output: 1 }

  # Validaciones
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :movement_type, :reason, presence: true
  
  # Validación con helper generado por Rails
  validate :sufficient_stock_for_output, if: :output?

  # Callback automático
  after_create :update_product_stock

  private

  def update_product_stock
    if input?
      product.increment!(:stock_current, quantity)
    elsif output?
      product.decrement!(:stock_current, quantity)
    end
  end

  def sufficient_stock_for_output
    if product.stock_current < quantity
      errors.add(:quantity, "insuficiente en inventario. Stock disponible actual: #{product.stock_current}")
    end
  end
end