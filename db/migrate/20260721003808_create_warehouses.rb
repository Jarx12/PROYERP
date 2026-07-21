class CreateWarehouses < ActiveRecord::Migration[8.0]
  def change
    create_table :warehouses do |t|
      t.string :name
      t.string :code
      t.string :address

      t.timestamps
    end
  end
end
