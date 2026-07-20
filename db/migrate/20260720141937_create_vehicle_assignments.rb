class CreateVehicleAssignments < ActiveRecord::Migration[8.0]
  def change
    create_table :vehicle_assignments do |t|
      t.references :vehicle, null: false, foreign_key: true
      t.references :employee, null: false, foreign_key: true
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end
  end
end
