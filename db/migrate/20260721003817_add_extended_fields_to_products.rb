class AddExtendedFieldsToProducts < ActiveRecord::Migration[8.0]
  def change
    add_reference :products, :category, foreign_key: true, null: true
    add_reference :products, :warehouse, foreign_key: true, null: true
    add_column :products, :location_detail, :string
    add_column :products, :price_cost, :decimal, precision: 10, scale: 2, default: 0.0
    add_column :products, :price_sale, :decimal, precision: 10, scale: 2, default: 0.0
    add_column :products, :weight, :decimal, precision: 8, scale: 3
  end
end
