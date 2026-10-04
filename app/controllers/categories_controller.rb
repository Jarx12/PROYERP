class CategoriesController < ApplicationController
  before_action :set_category, only: %i[edit update destroy]

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories or /categories.json
  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        format.html { redirect_to settings_path, notice: "Categoría creada exitosamente." }
        format.json { render :show, status: :created, location: @category }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1 or /categories/1.json
  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to settings_path, notice: "Categoría actualizada exitosamente.", status: :see_other }
        format.json { render :show, status: :ok, location: @category }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1 or /categories/1.json
  def destroy
    @category.destroy!

    respond_to do |format|
      format.html { redirect_to settings_path, notice: "Categoría eliminada exitosamente.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  # Callbacks compartidos
  def set_category
    @category = Category.find(params[:id])
  end

  # Parámetros permitidos
  def category_params
    params.require(:category).permit(:name, :description)
  end
end
