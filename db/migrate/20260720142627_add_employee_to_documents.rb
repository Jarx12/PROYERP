class AddEmployeeToDocuments < ActiveRecord::Migration[8.0]
  def change
    add_reference :documents, :employee, null: false, foreign_key: true
  end
end
