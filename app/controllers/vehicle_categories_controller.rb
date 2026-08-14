class VehicleCategoriesController < ApplicationController
  before_action :set_vehicle_category, only: %i[edit update destroy]

  def new
    @vehicle_category = VehicleCategory.new
  end

  def edit
  end

  def create
    @vehicle_category = VehicleCategory.new(vehicle_category_params)

    if @vehicle_category.save
      redirect_to settings_path, notice: "Categoría de vehículo creada exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @vehicle_category.update(vehicle_category_params)
      redirect_to settings_path, notice: "Categoría de vehículo actualizada exitosamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @vehicle_category.destroy!
    redirect_to settings_path, notice: "Categoría de vehículo eliminada.", status: :see_other
  end

  private

  def set_vehicle_category
    @vehicle_category = VehicleCategory.find(params.expect(:id))
  end

  def vehicle_category_params
    params.expect(vehicle_category: [ :name, :description ])
  end
end