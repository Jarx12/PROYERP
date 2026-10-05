class ChangeVehicleCategoryIdToNullableInVehicles < ActiveRecord::Migration[8.0]
  def change
    # Vehicle declara `belongs_to :vehicle_category, optional: true` (el formulario
    # ofrece "Seleccionar categoría..."), y VehicleCategory usa
    # `dependent: :nullify`, por lo que la columna debe admitir valores NULL.
    change_column_null :vehicles, :vehicle_category_id, true
  end
end
