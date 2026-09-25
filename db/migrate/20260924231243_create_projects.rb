class CreateProjects < ActiveRecord::Migration[8.0]
  def change
    create_table :projects do |t|
      t.string :name
      t.date :start_date
      t.date :end_date
      t.string :location
      t.string :customer
      t.text :description

      t.timestamps
    end
  end
end
