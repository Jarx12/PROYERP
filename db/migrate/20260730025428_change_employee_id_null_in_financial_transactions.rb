class ChangeEmployeeIdNullInFinancialTransactions < ActiveRecord::Migration[8.0]
  def change
    change_column_null :financial_transactions, :employee_id, true
  end
end
