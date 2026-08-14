class AddExtendedFieldsToVehicles < ActiveRecord::Migration[8.0]
  def change
    add_column :vehicles, :engine_serial, :string
    add_column :vehicles, :body_serial, :string
    add_column :vehicles, :color, :string
    add_column :vehicles, :seats, :integer
    add_column :vehicles, :year, :integer
    add_column :vehicles, :load_capacity, :decimal, precision: 10, scale: 2
    add_column :vehicles, :owner_dni, :string
    add_column :vehicles, :condition, :integer
    add_column :vehicles, :policy_number, :string
    add_column :vehicles, :policy_expiration, :date
    add_reference :vehicles, :vehicle_category, null: false, foreign_key: true
  end
end
