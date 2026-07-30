class TransactionCategoriesController < ApplicationController
  before_action :set_transaction_category, only: %i[edit update destroy]

  def new
    @transaction_category = TransactionCategory.new
  end

  def create
    @transaction_category = TransactionCategory.new(transaction_category_params)
    if @transaction_category.save
      redirect_to settings_path, notice: "Categoría financiera creada exitosamente."
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @transaction_category.update(transaction_category_params)
      redirect_to settings_path, notice: "Categoría financiera actualizada exitosamente."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @transaction_category.destroy
    redirect_to settings_path, notice: "Categoría financiera eliminada.", status: :see_other
  end

  private

  def set_transaction_category
    @transaction_category = TransactionCategory.find(params[:id])
  end

  def transaction_category_params
    params.require(:transaction_category).permit(:name, :description)
  end
end