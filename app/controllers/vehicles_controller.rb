class VehiclesController < ApplicationController
  before_action :set_vehicle, only: %i[show edit update destroy]

  def index
    @vehicles = Vehicle.includes(:vehicle_category, :registration_title_attachment, :rcv_policy_attachment, :owner_dni_file_attachment).order(created_at: :desc)
    # Métricas para el stats-bar
    @total_vehicles       = Vehicle.count
    @available_vehicles   = Vehicle.available.count
    @in_use_vehicles      = Vehicle.in_use.count
    @maintenance_vehicles = Vehicle.maintenance.count
  end

  def show
    @vehicle = Vehicle.find(params[:id])
    @assignments = @vehicle.vehicle_assignments
                         .includes(:employee)
                         .order(created_at: :desc)
  end

  def new
    @vehicle = Vehicle.new
  end

  def edit
  end

  def create
    @vehicle = Vehicle.new(vehicle_params)

    if @vehicle.save
      redirect_to vehicles_path, notice: "Vehículo registrado exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @vehicle.update(vehicle_params)
      redirect_to vehicles_path, notice: "Vehículo actualizado exitosamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @vehicle.destroy!
    redirect_to vehicles_path, notice: "Vehículo eliminado exitosamente.", status: :see_other
  end

  private

  def set_vehicle
    @vehicle = Vehicle.find(params[:id])
  end

  # Strong Parameters limpios y garantizados
  def vehicle_params
    params.require(:vehicle).permit(
      :plate,
      :brand,
      :model,
      :status,
      :condition,
      :color,
      :seats,
      :year,
      :load_capacity,
      :owner_dni,
      :engine_serial,
      :body_serial,
      :policy_number,
      :policy_expiration,
      :vehicle_category_id,
      :registration_title,
      :rcv_policy,
      :owner_dni_file
    )
  end
end