class WarehousesController < ApplicationController
  before_action :set_warehouse, only: %i[edit update destroy]

  def new
    @warehouse = Warehouse.new
  end

  def edit
  end

  def create
    @warehouse = Warehouse.new(warehouse_params)

    respond_to do |format|
      if @warehouse.save
        format.html { redirect_to settings_path, notice: "Almacén creado exitosamente." }
        format.json { render :show, status: :created, location: @warehouse }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @warehouse.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @warehouse.update(warehouse_params)
        format.html { redirect_to settings_path, notice: "Almacén actualizado exitosamente.", status: :see_other }
        format.json { render :show, status: :ok, location: @warehouse }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @warehouse.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @warehouse.destroy!

    respond_to do |format|
      format.html { redirect_to settings_path, notice: "Almacén eliminado exitosamente.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  def set_warehouse
    @warehouse = Warehouse.find(params[:id])
  end

  def warehouse_params
    params.require(:warehouse).permit(:name, :code, :address)
  end
end
