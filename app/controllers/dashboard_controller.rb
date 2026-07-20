class DashboardController < ApplicationController
  def index
    # Contadores para el Dashboard
    @total_employees = Employee.count
    @total_documents = Document.count
    @total_products = Product.count
    # Próximamente cuando desarrolles los otros módulos:
    # @total_vehicles = Vehicle.count
    # @low_stock_products = Product.where("stock_current <= stock_minimum").count
  end
end
