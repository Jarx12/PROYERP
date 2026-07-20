class CreateStockMovements < ActiveRecord::Migration[8.0]
  def change
    create_table :stock_movements do |t|
      t.references :product, null: false, foreign_key: true
      t.integer :quantity
      t.integer :movement_type
      t.string :reason

      t.timestamps
    end
  end
end
