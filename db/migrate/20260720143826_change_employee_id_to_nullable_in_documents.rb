class ChangeEmployeeIdToNullableInDocuments < ActiveRecord::Migration[8.0]
  def change
    # Permite que la columna employee_id acepte valores NULL (nulos)
    change_column_null :documents, :employee_id, true
  end
end