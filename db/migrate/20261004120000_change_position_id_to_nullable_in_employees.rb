class ChangePositionIdToNullableInEmployees < ActiveRecord::Migration[8.0]
  def change
    # Employee declara `belongs_to :position, optional: true` y Position usa
    # `dependent: :nullify`, por lo que la columna debe admitir valores NULL.
    change_column_null :employees, :position_id, true
  end
end
