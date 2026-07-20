class CreateEmployees < ActiveRecord::Migration[8.0]
  def change
    create_table :employees do |t|
      t.string :name
      t.string :surname
      t.string :name2
      t.string :surname2
      t.integer :cedula
      t.string :direccion
      t.string :telefono
      t.date :birthday
      t.date :hire_date
      t.decimal :salary

      t.timestamps
    end
    add_index :employees, :cedula, unique: true
  end
end
