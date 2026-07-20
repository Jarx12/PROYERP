class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :sku
      t.integer :stock_current
      t.integer :stock_minimum

      t.timestamps
    end
  end
end
